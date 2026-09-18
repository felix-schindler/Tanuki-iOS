//
//  SHA256Hash.swift
//  Tanuki
//
//  Created by Felix Schindler on 18.09.26.
//

import Foundation

#if SKIP_BRIDGE

	enum SHA256Hash {
		static func hash(_ data: Data) -> Data {
			Data(digest(Array(data)))
		}

		static func digest(_ bytes: [UInt8]) -> [UInt8] {
			var state: [UInt32] = [
				0x6a09_e667, 0xbb67_ae85, 0x3c6e_f372, 0xa54f_f53a,
				0x510e_527f, 0x9b05_688c, 0x1f83_d9ab, 0x5be0_cd19,
			]

			var message = bytes
			let bitLength = UInt64(bytes.count) * 8
			message.append(0x80)
			while message.count % 64 != 56 {
				message.append(0)
			}
			for shift in stride(from: 56, through: 0, by: -8) {
				message.append(UInt8(truncatingIfNeeded: bitLength >> UInt64(shift)))
			}

			var schedule = [UInt32](repeating: 0, count: 64)
			for chunk in stride(from: 0, to: message.count, by: 64) {
				for index in 0..<16 {
					let offset = chunk + index * 4
					schedule[index] =
						UInt32(message[offset]) << 24 | UInt32(message[offset + 1]) << 16
						| UInt32(message[offset + 2]) << 8 | UInt32(message[offset + 3])
				}
				for index in 16..<64 {
					let s0 =
						rotate(schedule[index - 15], 7) ^ rotate(schedule[index - 15], 18)
						^ (schedule[index - 15] >> 3)
					let s1 =
						rotate(schedule[index - 2], 17) ^ rotate(schedule[index - 2], 19)
						^ (schedule[index - 2] >> 10)
					schedule[index] = schedule[index - 16] &+ s0 &+ schedule[index - 7] &+ s1
				}

				var a = state[0]
				var b = state[1]
				var c = state[2]
				var d = state[3]
				var e = state[4]
				var f = state[5]
				var g = state[6]
				var h = state[7]

				for index in 0..<64 {
					let s1 = rotate(e, 6) ^ rotate(e, 11) ^ rotate(e, 25)
					let choice = (e & f) ^ (~e & g)
					let temp1 = h &+ s1 &+ choice &+ constants[index] &+ schedule[index]
					let s0 = rotate(a, 2) ^ rotate(a, 13) ^ rotate(a, 22)
					let majority = (a & b) ^ (a & c) ^ (b & c)
					let temp2 = s0 &+ majority

					h = g
					g = f
					f = e
					e = d &+ temp1
					d = c
					c = b
					b = a
					a = temp1 &+ temp2
				}

				state[0] = state[0] &+ a
				state[1] = state[1] &+ b
				state[2] = state[2] &+ c
				state[3] = state[3] &+ d
				state[4] = state[4] &+ e
				state[5] = state[5] &+ f
				state[6] = state[6] &+ g
				state[7] = state[7] &+ h
			}

			var digest = [UInt8]()
			digest.reserveCapacity(32)
			for value in state {
				digest.append(UInt8(truncatingIfNeeded: value >> 24))
				digest.append(UInt8(truncatingIfNeeded: value >> 16))
				digest.append(UInt8(truncatingIfNeeded: value >> 8))
				digest.append(UInt8(truncatingIfNeeded: value))
			}
			return digest
		}

		private static func rotate(_ value: UInt32, _ amount: UInt32) -> UInt32 {
			(value >> amount) | (value << (32 - amount))
		}

		private static let constants: [UInt32] = [
			0x428a_2f98, 0x7137_4491, 0xb5c0_fbcf, 0xe9b5_dba5, 0x3956_c25b, 0x59f1_11f1, 0x923f_82a4, 0xab1c_5ed5,
			0xd807_aa98, 0x1283_5b01, 0x2431_85be, 0x550c_7dc3, 0x72be_5d74, 0x80de_b1fe, 0x9bdc_06a7, 0xc19b_f174,
			0xe49b_69c1, 0xefbe_4786, 0x0fc1_9dc6, 0x240c_a1cc, 0x2de9_2c6f, 0x4a74_84aa, 0x5cb0_a9dc, 0x76f9_88da,
			0x983e_5152, 0xa831_c66d, 0xb003_27c8, 0xbf59_7fc7, 0xc6e0_0bf3, 0xd5a7_9147, 0x06ca_6351, 0x1429_2967,
			0x27b7_0a85, 0x2e1b_2138, 0x4d2c_6dfc, 0x5338_0d13, 0x650a_7354, 0x766a_0abb, 0x81c2_c92e, 0x9272_2c85,
			0xa2bf_e8a1, 0xa81a_664b, 0xc24b_8b70, 0xc76c_51a3, 0xd192_e819, 0xd699_0624, 0xf40e_3585, 0x106a_a070,
			0x19a4_c116, 0x1e37_6c08, 0x2748_774c, 0x34b0_bcb5, 0x391c_0cb3, 0x4ed8_aa4a, 0x5b9c_ca4f, 0x682e_6ff3,
			0x748f_82ee, 0x78a5_636f, 0x84c8_7814, 0x8cc7_0208, 0x90be_fffa, 0xa450_6ceb, 0xbef9_a3f7, 0xc671_78f2,
		]
	}

#endif
