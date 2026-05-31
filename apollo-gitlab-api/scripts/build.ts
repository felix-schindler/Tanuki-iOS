#!/usr/bin/env -S deno run --allow-read --allow-write --allow-env

/**
 * Code generator for the GitLab API dual-platform Swift package.
 *
 * Reads all .graphql operation files from config/ and produces:
 *   - Queries.swift       – query structs with nested Codable response types
 *   - FilterModels.swift  – Encodable filter structs from query variables
 *   - GitLabServiceExtensions.swift – typed convenience methods on GitLabServiceType
 *
 * No tier distinction: every query gets its response type generated from
 * its selection set.  List queries whose root field is in T1_MAP get their
 * node items mapped to the declared protocol struct.
 */

import { walk } from "jsr:@std/fs";

// ─── Paths ──────────────────────────────────────────────────────────────

const WORK_DIR = new URL("..", import.meta.url).pathname;
const CONFIG_DIR = `${WORK_DIR}/config`;
const SERVICE_DIR = `${WORK_DIR}/dual-platform/Sources/GitLabAPI/Service`;

// ─── Root field → protocol/struct mapping (list queries) ────────────────

interface ListSpec { proto: string; struct: string }

const T1_MAP: Record<string, ListSpec> = {
  projects:                    { proto: "SmallProject",          struct: "SmallProjectStruct" },
  starredProjects:             { proto: "SmallProject",          struct: "SmallProjectStruct" },
  groups:                      { proto: "Group",                 struct: "GroupStruct" },
  issues:                      { proto: "SmallIssue",            struct: "SmallIssueStruct" },
  mergeRequests:               { proto: "SmallMergeRequest",     struct: "SmallMergeRequestStruct" },
  assignedMergeRequests:       { proto: "UserSmallMergeRequest", struct: "UserSmallMergeRequestStruct" },
  authoredMergeRequests:       { proto: "UserSmallMergeRequest", struct: "UserSmallMergeRequestStruct" },
  reviewRequestedMergeRequests:{ proto: "UserSmallMergeRequest", struct: "UserSmallMergeRequestStruct" },
  labels:                      { proto: "MyLabel",               struct: "MyLabelStruct" },
  milestones:                  { proto: "Milestone",             struct: "MilestoneStruct" },
  timelogs:                    { proto: "Timelog",               struct: "TimelogStruct" },
  todos:                       { proto: "Todo",                  struct: "TodoStruct" },
  snippets:                    { proto: "Snippet",               struct: "SnippetStruct" },
  releases:                    { proto: "Release",               struct: "ReleaseStruct" },
  users:                       { proto: "Author",                struct: "MyAuthor" },
  // projectMemberships:      { proto: "Member",                struct: "MemberStruct" },
};

// ─── Types ───────────────────────────────────────────────────────────────

interface Variable {
  name: string;
  type: string;       // raw GraphQL type
  isRequired: boolean;
  isEnum: boolean;
}

interface SelNode {
  name: string;
  children: SelNode[];
  isConnection: boolean; // direct children include 'nodes'
}

interface QueryDef {
  operationType: string;
  operationName: string;
  variables: Variable[];
  queryString: string;
  selection: SelNode[];
  rootField: string;
  connField: string;    // connection field (may = rootField)
  chain: string[];       // path from root to connection, e.g. ["group", "labels"]
  isList: boolean;
  listSpec?: ListSpec;
}

// ─── Enums ───────────────────────────────────────────────────────────────

const ENUM_NAMES = new Set([
  "AccessLevelEnum", "DetailedMergeStatus", "EpicState", "IssuableState",
  "IssueState", "IssueStateEvent", "IssueType", "MergeRequestState",
  "MergeStatus", "MilestoneStateEnum", "PipelineStatusEnum", "ProjectArchived",
  "SubscriptionStatus", "TodoActionEnum", "TodoStateEnum", "TodoTargetEnum",
  "UserState", "VerificationStatus", "VisibilityLevelsEnum",
]);

const ASYNC_METHODS: Record<string, boolean> = {
  Project: true, MergeRequest: true, Snippet: true, Group: true,
  User: true, CurrentUser: true, Epic: true, Issue: true,
  RepoTree: true, MergeRequestDiffs: true, GroupEpics: true,
  GroupCustomEmoji: true, ProjectPipelines: true,
};

// ─── Helpers ─────────────────────────────────────────────────────────────

function swiftScalar(gqlType: string): string {
  const inner = gqlType.replace(/[[\]!]/g, "");
  if (ENUM_NAMES.has(inner)) return inner;
  if (inner === "Boolean") return "Bool";
  if (inner === "Int" || inner === "Float") return gqlType;
  return "String";
}

function pascal(s: string): string {
  return s.charAt(0).toUpperCase() + s.slice(1);
}

// ─── Character-stream parser for GraphQL ─────────────────────────────────

/** Split `content` into individual operation strings. */
function splitOperations(content: string): { header: string; body: string; full: string }[] {
  const ops: { header: string; body: string; full: string }[] = [];
  const len = content.length;
  let i = 0;

  while (i < len) {
    // Find next "query " or "mutation "
    const rest = content.slice(i);
    const m = rest.match(/\n?(query|mutation)\s/) || rest.match(/^(query|mutation)\s/);
    if (!m) break;
    const start = i + (m.index ?? 0);
    const opType = m[1];
    i = start + m[0].length;

    // Read operation name
    let opName = "";
    while (i < len && /[\w_]/.test(content[i])) { opName += content[i]; i++; }

    // Skip whitespace then variables block if present
    if (i < len && content[i] === "(") {
      let depth = 1; i++;
      while (i < len && depth > 0) {
        if (content[i] === "(") depth++;
        else if (content[i] === ")") depth--;
        i++;
      }
    }

    // Skip to opening brace
    while (i < len && content[i] !== "{") i++;
    if (i >= len) break;

    // Find matching closing brace
    let braceDepth = 0;
    const bodyStart = i;
    while (i < len) {
      if (content[i] === "{") braceDepth++;
      if (content[i] === "}") braceDepth--;
      if (braceDepth === 0) { i++; break; }
      i++;
    }
    const bodyEnd = i;

    const full = content.slice(start, bodyEnd).trim();
    const header = content.slice(start, bodyStart).trim();
    const body = content.slice(bodyStart, bodyEnd).trim(); // includes outer braces

    ops.push({ header, body: body.slice(1, -1).trim(), full });
  }
  return ops;
}

/** Parse variables from an operation header like "( $a: String!, $b: Boolean )". */
function parseVariables(header: string): Variable[] {
  const vars: Variable[] = [];
  let i = header.indexOf("(");
  if (i < 0) return vars;
  const vStr = header.slice(i + 1).replace(/\)\s*$/, "");

  // Split on "$" to find variables
  const parts = vStr.split(/\s*,\s*\$/);
  for (const part of parts) {
    let p = part.startsWith("$") ? part.slice(1) : part;
    const colon = p.indexOf(":");
    if (colon < 0) continue;
    const name = p.slice(0, colon).trim();
    if (!name) continue;
    const type = p.slice(colon + 1).trim();
    if (!type) continue;

    const isRequired = type.endsWith("!");
    const inner = type.replace(/[[\]!]/g, "");
    vars.push({ name, type, isRequired, isEnum: ENUM_NAMES.has(inner) });
  }
  return vars;
}

/** Parse GraphQL selection set body into a field tree. */
function parseSelection(body: string): SelNode[] {
  const out: SelNode[] = [];
  let i = 0;
  const len = body.length;

  function skipWS() {
    while (i < len && (body[i] === " " || body[i] === "\t" || body[i] === "\n" || body[i] === "\r" || body[i] === ",")) i++;
  }

  function skipParens() {
    let d = 1; i++;
    while (i < len && d > 0) {
      if (body[i] === "(") d++;
      else if (body[i] === ")") d--;
      i++;
    }
  }

  function readName() {
    let n = "";
    while (i < len && /[\w_]/.test(body[i])) { n += body[i]; i++; }
    return n;
  }

  function parseFieldList(): SelNode[] {
    const fields: SelNode[] = [];
    skipWS();
    while (i < len) {
      skipWS();
      if (i >= len || body[i] === "}") break;

      // Inline fragment: ... on Type { }
      if (body[i] === "." && i + 2 < len && body[i + 1] === "." && body[i + 2] === ".") {
        i += 3; skipWS();
        if (i + 1 < len && body[i] === "o" && body[i + 1] === "n") { i += 2; skipWS(); readName(); skipWS(); }
        if (i < len && body[i] === "{") { i++; fields.push(...parseFieldList()); skipWS(); if (i < len && body[i] === "}") i++; }
        continue;
      }

      // Fragment spread
      if (body[i] === ".") { while (i < len && body[i] !== "\n") i++; continue; }

      // Directive
      if (body[i] === "@") { while (i < len && body[i] !== "\n" && body[i] !== " ") { i++; } skipWS(); continue; }

      const fieldName = readName();
      if (!fieldName) break;
      skipWS();

      if (i >= len) { fields.push({ name: fieldName, children: [], isConnection: false }); break; }

      // Alias: aliasName
      if (body[i] === ":") {
        i++; skipWS();
        const actual = readName();
        skipWS();
        if (i < len && body[i] === "(") { skipParens(); skipWS(); }
        if (i < len && body[i] === "{") {
          i++;
          const children = parseFieldList();
          skipWS();
          if (i < len && body[i] === "}") i++;
          const hasNodes = children.some(c => c.name === "nodes");
          fields.push({ name: fieldName, children, isConnection: hasNodes });
        } else {
          fields.push({ name: fieldName, children: [], isConnection: false });
        }
        continue;
      }

      // Arguments
      if (body[i] === "(") { skipParens(); skipWS(); }

      // Children
      if (i < len && body[i] === "{") {
        i++;
        const children = parseFieldList();
        skipWS();
        if (i < len && body[i] === "}") i++;
        const hasNodes = children.some(c => c.name === "nodes");
        fields.push({ name: fieldName, children, isConnection: hasNodes });
        continue;
      }

      fields.push({ name: fieldName, children: [], isConnection: false });
    }
    return fields;
  }

  return parseFieldList();
}

/** Parse one .graphql file into QueryDef objects. */

/** Find a list connection in the selection tree. A query is a "list query" if
 *  the deepest connection has a field name in T1_MAP.  Returns the root field,
 *  connection field, and spec. */
function findListConnection(sel: SelNode[]): { rootField: string; connField: string; spec: ListSpec } | null {
  if (sel.length !== 1) return null;
  const root = sel[0];

  // Root IS the connection (e.g. projects { nodes { ... } })
  if (root.isConnection) {
    const spec = T1_MAP[root.name];
    if (spec) {
      const nodesKid = root.children.find(c => c.name === "nodes");
      if (nodesKid && nodesKid.children.length > 0)
        return { rootField: root.name, connField: root.name, spec };
    }
  }

  // Root wraps a connection (e.g. group { labels { nodes { ... } } })
  for (const child of root.children) {
    if (child.isConnection && T1_MAP[child.name]) {
      const nodesKid = child.children.find(c => c.name === "nodes");
      if (nodesKid && nodesKid.children.length > 0)
        return { rootField: root.name, connField: child.name, spec: T1_MAP[child.name] };
    }
  }

  return null;
}

function parseFile(content: string): QueryDef[] {
  const ops = splitOperations(content);
  return ops.map(op => {
    // Parse header: "query Name ($vars...)"
    const headerClean = op.header.replace(/\n/g, " ").replace(/\s+/g, " ").trim();
    const hm = headerClean.match(/^(query|mutation)\s+(\w+)/);
    if (!hm) throw new Error(`Cannot parse header: ${headerClean.slice(0, 80)}`);
    const operationType = hm[1];
    const operationName = hm[2];

    const variables = parseVariables(op.header);
    const selection = parseSelection(op.body);
    const rootField = selection.length > 0 ? selection[0].name : "";
    const listInfo = findListConnection(selection);
    const isList = listInfo !== null;
    const connField = listInfo ? listInfo.connField : rootField;
    const chain = listInfo && listInfo.rootField !== listInfo.connField
      ? [listInfo.rootField, listInfo.connField]
      : [rootField];

    return {
      operationType, operationName, variables,
      queryString: op.full,
      selection, rootField, connField, chain,
      isList, listSpec: listInfo?.spec,
    };
  });
}

// ─── Code generation ────────────────────────────────────────────────────

function genStructName(opName: string, ...parts: string[]): string {
  return [opName, ...parts].map(pascal).join("_");
}

function swiftField(q: QueryDef, node: SelNode, prefix: string): string {
  if (node.name === "nodes") {
    const spec = q.listSpec;
    return spec ? `[${spec.struct}]` : "[Any]";
  }
  if (node.children.length > 0) {
    return genStructName(prefix, node.name);
  }
  return "String";
}

function genResponseType(q: QueryDef): string {
  if (q.isList && q.listSpec) {
    // List query: generate wrapper types for each level, ending with nodes
    let out = "";
    let innerType = "root";

    for (let level = q.chain.length - 1; level >= 0; level--) {
      const field = q.chain[level];
      const isLast = level === q.chain.length - 1;
      if (isLast) {
        innerType = genStructName(q.operationName, field);
        out = `\tpublic struct ${innerType}: Decodable, Sendable {\n\t\tpublic let nodes: [${q.listSpec!.struct}]?\n\t}\n\n` + out;
      } else {
        const outerType = genStructName(q.operationName, field);
        const nextField = q.chain[level + 1];
        const nextType = genStructName(q.operationName, nextField);
        out = `\tpublic struct ${outerType}: Decodable, Sendable {\n\t\tpublic let ${nextField}: ${nextType}?\n\t}\n\n` + out;
        innerType = outerType;
      }
    }

    // Response envelope
    const rootType = genStructName(q.operationName, q.rootField);
    out = `\tpublic struct ${q.operationName}Response: Decodable, Sendable {\n\t\tpublic let ${q.rootField}: ${rootType}?\n\t}\n\n` + out;

    return out;
  }

  // Complex query: walk selection tree and generate nested structs
  let out = "";
  const sel = q.selection;
  if (sel.length === 0) return out;

  // All generated struct names
  const generated = new Set<string>();
  const structDefs: { name: string; body: string }[] = [];

  function walk(nodes: SelNode[], parentName: string): string {
    let body = "";
    const seen = new Set<string>();
    for (const n of nodes) {
      if (seen.has(n.name)) continue;
      seen.add(n.name);
      if (n.children.length === 0) {
        body += `\t\tpublic let ${n.name}: String?\n`;
      } else if (n.isConnection) {
        // Connection: has nodes child → generate wrapper
        const connName = genStructName(parentName, n.name);
        if (!generated.has(connName)) {
          generated.add(connName);
          let connBody = "";
          let innerTypeName = "Any";
          const nodesChild = n.children.find(c => c.name === "nodes");
          if (nodesChild) {
            innerTypeName = genStructName(connName, "Nodes");
            generated.add(innerTypeName);
            connBody += `\t\tpublic let nodes: [${innerTypeName}]?\n`;
            let innerBody = "";
            for (const nc of nodesChild.children) {
              if (nc.children.length > 0) {
                const cn = genStructName(innerTypeName, nc.name);
                innerBody += `\t\tpublic let ${nc.name}: ${cn}?\n`;
                structDefs.push({ name: cn, body: walk(nc.children, cn) });
              } else {
                innerBody += `\t\tpublic let ${nc.name}: String?\n`;
              }
            }
            structDefs.push({ name: innerTypeName, body: innerBody });
          }
          structDefs.push({ name: connName, body: connBody });
        }
        body += `\t\tpublic let ${n.name}: ${connName}?\n`;
      } else {
        // Nested object
        const nestedName = genStructName(parentName, n.name);
        if (!generated.has(nestedName)) {
          generated.add(nestedName);
          structDefs.push({ name: nestedName, body: walk(n.children, nestedName) });
        }
        body += `\t\tpublic let ${n.name}: ${nestedName}?\n`;
      }
    }
    return body;
  }

  // Build root response type
  const rootSel = sel[0];
  const rootTypeName = genStructName(q.operationName, rootSel.name);
  generated.add(q.operationName + "Response");
  let rootBody = "";
  const rootSeen = new Set<string>();
  for (const n of rootSel.children) {
    if (rootSeen.has(n.name)) continue;
    rootSeen.add(n.name);
    if (n.children.length === 0) {
      rootBody += `\t\tpublic let ${n.name}: String?\n`;
    } else if (n.isConnection) {
      const connName = genStructName(rootTypeName, n.name);
      if (!generated.has(connName)) {
        generated.add(connName);
        let innerTypeName = "Any";
        const nodesChild = n.children.find(c => c.name === "nodes");
        if (nodesChild) {
          innerTypeName = genStructName(connName, "Nodes");
          generated.add(innerTypeName);
          let innerBody = "";
          for (const nc of nodesChild.children) {
            if (nc.children.length > 0) {
              const cn = genStructName(innerTypeName, nc.name);
              innerBody += `\t\tpublic let ${nc.name}: ${cn}?\n`;
              structDefs.push({ name: cn, body: walk(nc.children, cn) });
            } else {
              innerBody += `\t\tpublic let ${nc.name}: String?\n`;
            }
          }
          structDefs.push({ name: innerTypeName, body: innerBody });
        }
        structDefs.push({ name: connName, body: `\t\tpublic let nodes: [${innerTypeName}]?\n` });
      }
      rootBody += `\t\tpublic let ${n.name}: ${connName}?\n`;
    } else {
      const nestedName = genStructName(rootTypeName, n.name);
      if (!generated.has(nestedName)) {
        generated.add(nestedName);
        structDefs.push({ name: nestedName, body: walk(n.children, nestedName) });
      }
      rootBody += `\t\tpublic let ${n.name}: ${nestedName}?\n`;
    }
  }

  // Output
  out += `\tpublic struct ${q.operationName}Response: Decodable, Sendable {\n`;
  out += `\t\tpublic let ${rootSel.name}: ${rootTypeName}?\n`;
  out += `\t}\n\n`;
  out += `\tpublic struct ${rootTypeName}: Decodable, Sendable {\n${rootBody}\t}\n\n`;

  for (const sd of structDefs) {
    out += `\tpublic struct ${sd.name}: Decodable, Sendable {\n${sd.body}\t}\n\n`;
  }

  return out;
}

function genQueryStruct(q: QueryDef): string {
  const hasVars = q.variables.length > 0;
  const varTypeName = hasVars ? `${q.operationName}Filter` : "EmptyVariables";
  let out = "";

  out += `// MARK: - ${q.operationName}\n\n`;
  out += `public struct ${q.operationName}Query: GitLabQuery {\n`;
  out += `\tpublic let operationName = "${q.operationName}"\n`;
  out += `\tpublic let queryString = """\n${q.queryString.split("\n").map(l => "\t\t" + l).join("\n")}\n\t\t"""\n`;
  out += `\tpublic let variablesJSON: Data\n`;
  out += `\tpublic typealias Response = ${q.operationName}Response\n\n`;

  if (hasVars) {
    const optVars = q.variables.filter(v => !v.isRequired);
    const reqVars = q.variables.filter(v => v.isRequired);

    if (optVars.length > 0) {
      // Has optional vars — use filter struct, but also include required vars in init
      const reqParams = reqVars.map(v => `${v.name}: ${swiftScalar(v.type)}`).join(", ");
      out += `\tpublic init(variablesJSON: Data) { self.variablesJSON = variablesJSON }\n`;
      const initSig = reqVars.length > 0
        ? `${reqParams}, filter: ${varTypeName} = ${varTypeName}()`
        : `filter: ${varTypeName} = ${varTypeName}()`;
      out += `\tpublic init(${initSig}) {\n`;
      if (reqVars.length > 0) {
        // Encode required vars + filter together
        const encPairs = reqVars.map(v => `"${v.name}": ${v.name}`).join(", ");
        out += `\t\tvar dict = [${encPairs}] as [String: Any]\n`;
        out += `\t\tif let filterData = try? JSONEncoder().encode(filter),\n`;
        out += `\t\t   let filterDict = try? JSONSerialization.jsonObject(with: filterData) as? [String: Any] {\n`;
        out += `\t\t\tfor (k, v) in filterDict { dict[k] = v }\n`;
        out += `\t\t}\n`;
        out += `\t\tself.variablesJSON = (try? JSONSerialization.data(withJSONObject: dict)) ?? Data()\n`;
      } else {
        out += `\t\tself.variablesJSON = (try? JSONEncoder().encode(filter)) ?? Data()\n`;
      }
      out += `\t}\n`;
    } else {
      // Only required vars — encode directly
      const encParams = reqVars.map(v => `"${v.name}": ${v.name}`).join(", ");
      out += `\tpublic init(${reqVars.map(v => `${v.name}: ${swiftScalar(v.type)}`).join(", ")}) {\n`;
      if (reqVars.length > 0) {
        out += `\t\tlet dict: [String: Any] = [${encParams}]\n`;
        out += `\t\tself.variablesJSON = (try? JSONSerialization.data(withJSONObject: dict)) ?? Data()\n`;
      } else {
        out += `\t\tself.variablesJSON = Data()\n`;
      }
      out += `\t}\n`;
    }
  } else {
    out += `\tpublic init() { self.variablesJSON = Data() }\n`;
  }
  out += `}\n\n`;
  return out;
}

function genTopLevelResponseType(q: QueryDef): string {
  return genResponseType(q).replace(/^\t/gm, ""); // remove indentation
}

// ─── Filter models ──────────────────────────────────────────────────────

function genFilters(queries: QueryDef[]): string {
  const structs: { name: string; fields: Variable[] }[] = [];
  for (const q of queries) {
    const optVars = q.variables.filter(v => !v.isRequired);
    if (optVars.length === 0) continue;
    structs.push({ name: `${q.operationName}Filter`, fields: optVars });
  }
  if (structs.length === 0) return "// No filter structs\n";

  let out = `import Foundation\n\n`;
  out += `// Auto-generated filter models. Generated by scripts/build.ts – do not edit manually.\n\n`;

  for (const s of structs) {
    out += `public struct ${s.name}: Codable, Sendable {\n`;
    for (const f of s.fields) {
      out += `\tpublic var ${f.name}: ${swiftScalar(f.type)}? = nil\n`;
    }
    out += `\tpublic init(${s.fields.map(f => `${f.name}: ${swiftScalar(f.type)}? = nil`).join(", ")}) {\n`;
    for (const f of s.fields) out += `\t\tself.${f.name} = ${f.name}\n`;
    out += `\t}\n}\n\n`;
  }
  return out;
}

// ─── Service extensions ─────────────────────────────────────────────────

function genServiceExt(queries: QueryDef[]): string {
  let out = `import Foundation\n\n`;
  out += `// Auto-generated convenience methods for GitLabServiceType.\n`;
  out += `// Generated by scripts/build.ts – do not edit manually.\n\n`;
  out += `extension GitLabServiceType {\n\n\t// MARK: - Queries\n\n`;

  for (const q of queries) {
    const fnName = `fetch${q.operationName}`;
    const hasVars = q.variables.length > 0;
    const varType = hasVars ? `${q.operationName}Filter` : "EmptyVariables";
    const asyncPrefix = ASYNC_METHODS[q.operationName] ? "" : "";

    const parts: string[] = [];
    for (const v of q.variables.filter(v => v.isRequired)) parts.push(`${v.name}: ${swiftScalar(v.type)}`);
    if (hasVars && q.variables.some(v => !v.isRequired)) parts.push(`filter: ${varType} = ${varType}()`);
    parts.push("strategy: FetchStrategy = .cacheFirst");
    const params = parts.join(", ");

    if (q.isList && q.listSpec) {
      // Build chain accessors: e.g. response.group?.labels?.nodes
      const chainAccess = q.chain.join("?.") + "?.nodes";
      out += `\tpublic func ${fnName}(${params}) async throws -> [${q.listSpec.proto}] {\n`;
      const hasOptVars = hasVars && q.variables.some(v => !v.isRequired);
    const initArgs = [
      ...q.variables.filter(v => v.isRequired).map(v => `${v.name}: ${v.name}`),
      ...(hasOptVars ? ["filter: filter"] : [])
    ];
      out += `\t\tlet q = ${q.operationName}Query(${initArgs.join(", ")})\n`;
      out += `\t\tlet response = try await fetch(q, strategy: strategy)\n`;
      out += `\t\treturn response.${chainAccess}?.compactMap { $0 } ?? []\n`;
      out += `\t}\n\n`;
    } else {
      const rt = genStructName(q.operationName, q.rootField);
      out += `\tpublic func ${fnName}(${params}) async throws -> ${rt} {\n`;
      const hasOptVars = hasVars && q.variables.some(v => !v.isRequired);
    const initArgs = [
      ...q.variables.filter(v => v.isRequired).map(v => `${v.name}: ${v.name}`),
      ...(hasOptVars ? ["filter: filter"] : [])
    ];
      out += `\t\tlet q = ${q.operationName}Query(${initArgs.join(", ")})\n`;
      out += `\t\tlet response = try await fetch(q, strategy: strategy)\n`;
      out += `\t\tguard let data = response.${q.rootField} else { throw GitLabError.noData }\n`;
      out += `\t\treturn data\n`;
      out += `\t}\n\n`;
    }
  }
  out += `}\n`;
  return out;
}

// ─── Main ────────────────────────────────────────────────────────────────

async function main() {
  const allQueries: QueryDef[] = [];
  const seen = new Set<string>();

  const fileIter = walk(CONFIG_DIR, { includeFiles: true, exts: [".graphql"] });
  const files: string[] = [];
  for await (const entry of fileIter) {
    if (entry.isFile && entry.name.endsWith(".graphql")) files.push(entry.path);
  }
  files.sort();

  for (const f of files) {
    const content = await Deno.readTextFile(f);
    const parsed = parseFile(content);
    for (const q of parsed) {
      if (seen.has(q.operationName)) continue;
      seen.add(q.operationName);
      allQueries.push(q);
    }
  }

  const listQ = allQueries.filter(q => q.isList);
  const complexQ = allQueries.filter(q => !q.isList);
  console.log(`Found ${allQueries.length} operations (${listQ.length} list, ${complexQ.length} complex)`);

  // Queries.swift
  let qOut = `import Foundation\n\n`;
  qOut += `// Auto-generated query structs with nested Codable response types.\n`;
  qOut += `// Generated by scripts/build.ts – do not edit manually.\n\n`;
  qOut += `public struct EmptyVariables: Encodable, Sendable { public init() {} }\n\n`;

  for (const q of allQueries) qOut += genQueryStruct(q);
  qOut += "\n// MARK: - Response types\n\n";
  for (const q of allQueries) qOut += genTopLevelResponseType(q);
  await Deno.writeTextFile(`${SERVICE_DIR}/Queries.swift`, qOut);
  console.log(`Wrote Queries.swift`);

  // FilterModels.swift
  const fOut = genFilters(allQueries);
  await Deno.writeTextFile(`${SERVICE_DIR}/FilterModels.swift`, fOut);
  console.log(`Wrote FilterModels.swift`);

  // GitLabServiceExtensions.swift
  const sOut = genServiceExt(allQueries);
  await Deno.writeTextFile(`${SERVICE_DIR}/GitLabServiceExtensions.swift`, sOut);
  console.log(`Wrote GitLabServiceExtensions.swift`);
}

main().catch(e => { console.error(e); Deno.exit(1); });
