﻿using System;
using System.IO;

namespace ElDinamicCalc
{
	public static class ExtendedConverter
	{
		public static decimal ReadExtended(this BinaryReader reader)
		{
			var tempBytes = new byte[10];
			reader.Read(tempBytes, 0, 10);
			return (decimal) ToDouble(tempBytes, 0);
		}

		//converts the next 10 bytes of Value starting at StartIndex into a decimal
		public static double ToDouble(byte[] value, int startIndex)
		{
			if (value == null)
				throw new ArgumentNullException("value");

			if (value.Length < startIndex + 10)
				throw new ArgumentException("Combination of Value length and StartIndex was not large enough.");

			//extract fields
			var s = (byte) (value[9] & 0x80);
			var e = (short) (((value[9] & 0x7F) << 8) | value[8]);
			var j = (byte) (value[7] & 0x80);
			long f = value[7] & 0x7F;
			for (sbyte i = 6; i >= 0; i--)
			{
				f <<= 8;
				f |= value[i];
			}

			if (e == 0) //subnormal, pseudo-denormal or zero
				return 0;

			if (j == 0)
				throw new NotSupportedException();

			if (e == 0x7FFF) //+infinity, -infinity or nan
			{
				if (f != 0)
					return double.NaN;
				if (s == 0)
					return double.PositiveInfinity;
				return double.NegativeInfinity;
			}

			//translate f
			f >>= 11;

			//translate e
			e -= (0x3FFF - 0x3FF);

			if (e >= 0x7FF) //outside the range of a decimal
				throw new OverflowException();
			if (e < -51) //too small to translate into subnormal
				return 0;
			if (e < 0) //too small for normal but big enough to represent as subnormal
			{
				f |= 0x10000000000000;
				f >>= (1 - e);
				e = 0;
			}

			byte[] newBytes = BitConverter.GetBytes(f);

			newBytes[7] = (byte) (s | (e >> 4));
			newBytes[6] = (byte) (((e & 0x0F) << 4) | newBytes[6]);

			return BitConverter.ToDouble(newBytes, 0);
		}

		//converts Value into a long decimal byte array of length 10
		public static byte[] GetBytes(double value)
		{
			byte[] oldBytes = BitConverter.GetBytes(value);

			//extract fields
			var s = (byte) (oldBytes[7] & 0x80);
			var e = (short) (((oldBytes[7] & 0x7F) << 4) | ((oldBytes[6] & 0xF0) >> 4));
			byte j = 0x80;
			long f = oldBytes[6] & 0xF;
			for (sbyte i = 5; i >= 0; i--)
			{
				f <<= 8;
				f |= oldBytes[i];
			}

			//translate f
			f <<= 11;

			if (e == 0x7FF) //+infinity, -infinity or nan
				e = 0x7FFF;
			else if (e == 0 && f == 0) //zero
				j = 0;
			else //normal or subnormal
			{
				if (e == 0) //subnormal
				{
					f <<= 1;
					while (f > 0)
					{
						e--;
						f <<= 1;
					}
					f &= long.MaxValue;
				}

				e += (0x3FFF - 0x3FF); //translate e
			}

			var newBytes = new byte[10];
			BitConverter.GetBytes(f).CopyTo(newBytes, 0);

			newBytes[9] = (byte) (s | (e >> 8));
			newBytes[8] = (byte) (e & 0xFF);
			newBytes[7] = (byte) (j | newBytes[7]);

			return newBytes;
		}
	}
}