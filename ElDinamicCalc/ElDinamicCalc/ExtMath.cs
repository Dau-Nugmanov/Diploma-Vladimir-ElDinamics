using System;

namespace ElDinamicCalc
{
	public class ExtMath
	{
		public const decimal LeftLimit = 0.0m;
		public const decimal RightLimit = 0.0m;
		public const decimal Big = decimal.MaxValue;

		public const decimal Pi = (decimal) Math.PI;

		public Func<decimal, decimal> CustomFunction;
		public Func<decimal, decimal, decimal> CustomFunction2D;
		public Func<decimal, decimal, decimal, decimal> CustomFunction3D;

		public static decimal Degree(decimal x, decimal a)
		{
			return (decimal) Math.Pow((double) x, (double) a);
		}


		public static decimal Log(decimal x)
		{
			return (decimal) Math.Log10((double) x);
		}

		public static decimal Pow(decimal x, decimal y)
		{
			return (decimal) Math.Pow((double) x, (double) y);
		}

		public static bool FindRoot(Func<decimal, decimal> Funct, decimal Left,
			decimal Right, decimal Root, decimal Precision, int MaxCount)
		{
			do
			{
				try
				{
					Funct(Left);
					break;
				}
				catch (Exception)
				{
					Left = Left + (Right - Left)*Precision;
				}
			} while (Math.Abs(Left - Right)*1000 < Precision);

			if (Math.Abs(Left - Right)*1000 < Precision)
			{
				return false;
			}

			if (Funct(Left)*Funct(Right) > 0)
			{
				return false;
			}

			return FindRootR(Funct, ref Left, ref Right, ref MaxCount, ref Precision,
				ref Root);
		}

		private static bool FindRootR(Func<decimal, decimal> Funct,
			ref decimal Left, ref decimal Right, ref int MaxCount,
			ref decimal Precision, ref decimal Root)
		{
			decimal Mid;
			decimal FLeft, FRight, FMid;

			FLeft = Funct(Left);
			FRight = Funct(Right);

			for (int i = 0; i < MaxCount; i++)
			{
				Mid = Left - FLeft*(Right - Left)/(FRight - FLeft);
				FMid = Funct(Mid);
				if (Math.Abs(FMid) <= Precision)
				{
					Root = Mid;
					return true;
				}
				Left = Mid;
				FLeft = FMid;
			}
			return false;
		}

		public static bool Newton(Func<decimal, decimal> Funct,
			decimal NearRoot, decimal Root, decimal Precision, int MaxCount)
		{
			decimal Dy = 0;
			decimal NextRoot = 0;
			int Count = 0;
			Root = NearRoot;

			while (Math.Abs(Funct(Root)) > Precision)
			{
				Count++;
				try
				{
					Dy = (Funct(Root + Precision) - Funct(Root - Precision))/Precision/2;
				}
				catch (Exception)
				{
					try
					{
						Dy = (Funct(Root) - Funct(Root - Precision))/Precision;
					}
					catch (Exception)
					{
						return false;
					}
					throw;
				}
			}

			if (Dy == 0)
			{
				return false;
			}

			NextRoot = Root - Funct(Root)/Dy;
			if (LeftLimit < RightLimit)
			{
				if (NextRoot <= LeftLimit)
					NextRoot = LeftLimit + Precision;
				if (NextRoot >= RightLimit)
					NextRoot = RightLimit - Precision;
			}

			do
			{
				try
				{
					Funct(NextRoot);
				}
				catch (Exception)
				{
					NextRoot = (Root + NextRoot)/2;
				}
			} while (Math.Abs((NextRoot - Root))*100 < Precision);

			if (Math.Abs((NextRoot - Root))*100 < Precision)
			{
				return false;
			}

			Root = NextRoot;

			if (Count >= MaxCount)
			{
				return false;
			}

			if (Math.Abs(Root - NearRoot) >= Big)
			{
				return false;
			}

			if (Math.Abs(Funct(Root)) >= Big)
			{
				return false;
			}

			return true;
		}

		// x - a number, from which we need to calculate the square root
		// epsilon - an accuracy of calculation of the root from our number.
		// The result of the calculations will differ from an actual value
		// of the root on less than epslion.
		public static decimal Sqrt(decimal x, decimal epsilon = 0.0M)
		{
			if (x < 0)
				return 0;
			//throw new OverflowException("Cannot calculate square root from a negative number");

			return (decimal) Math.Sqrt((double) x);

			decimal current = (decimal) Math.Sqrt((double) x), previous;
			do
			{
				previous = current;
				if (previous == 0.0M) return 0;
				current = (previous + x/previous)/2;
			} while (Math.Abs(previous - current) > epsilon);
			return current;
		}

		public static decimal Sin(decimal a)
		{
			return (decimal) Math.Sin((double) a);
		}

		public static decimal Cos(decimal a)
		{
			return (decimal) Math.Cos((double) a);
		}

		public static decimal Exp(decimal a)
		{
			return (decimal) Math.Exp((double) a);
		}

		public static decimal Tan(decimal a)
		{
			return (decimal) Math.Tan((double) a);
		}
	}
}