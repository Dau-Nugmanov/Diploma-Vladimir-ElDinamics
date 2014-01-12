using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ElDinamicCalc
{
    /// <summary>
    /// {Модуль с математическими функциями
    ///TParser - переводит строку в функцию
    ///Degree - возводит число X в степень A
    ///Log - десятичный логарифм
    ///GetPeriod - период итерационной функции Funct с начальным условием
    ///  X0, переходным процессом Idle; возвращает период или: -1 при
    ///  расходимости, 0 при хаосе или периоде > MaxPeriod
    ///  (не опробовано)
    ///GetPeriod2D и GetPeriod3D - тоже для двумерного и трехмерного
    ///  случаев (не опробовано)
    ///RangeKut4 - метод Ранге-Кута 4-го порядка (не опробовано)
    ///Newton - нахождение корня уравнения методом Ньютона
    ///FindRoot - нахождение корня уравнения методом секущих}
    /// </summary>
    public class ExtMath
    {
        public const double LeftLimit = 0.0;
        public const double RightLimit = 0.0;
        public const double Big=1e100;

        public Func<double, double> TCustomFunction;
        public Func<double, double, double> TCustomFunction2D;
        public Func<double, double, double, double> TCustomFunction3D;

        public static decimal Degree(double x, double a)
        {
			return (decimal)Math.Pow(x, a);
        }


        public static double Log(double x)
        {
            return Math.Log10(x);
        }

        public static int GetPeriod(Func<double, double> Funct, double X0,
            double Eps, int Idle, int MaxPeriod)
        {

            double X;
            double XSt;
            
            if (Idle < 0 || MaxPeriod < 1)
            {
                throw new Exception("Неправильный параметр");
            }

            X = X0;
            for (int i = 0; i < Idle; i++)
            {
                X = Funct(X);
                if (Math.Abs(X) >= Big)
                {
                    return -1;
                }
            }
            XSt = X;
            for (int i = 0; i < MaxPeriod; i++)
            {
                if (Math.Abs(X) >= Big)
                {
                    return 0;
                }
                if (Math.Abs(X - XSt) <= Eps)
                {
                    return i;
                }
            }
            return 0;
        }

        public static int GetPeriod2D(Func<double, double, double> FunctX, Func<double, double, double> FunctY,
            double X0, double Y0, double Eps, int Idle, int MaxPeriod)
        {

            double X, Y, XSt, YSt, XT;
            
            if (Idle < 0 || MaxPeriod < 1)
            {
                throw new Exception("Неправильный параметр");
            }

            X = X0;
            Y = Y0;
            for (int i = 0; i < Idle; i++)
            {
                XT = FunctX(X, Y);
                Y = FunctY(X, Y);
                X = XT;
                if (Math.Abs(X) >= Big || Math.Abs(Y) >= Big)
                {
                    return -1;
                }
            }

            XSt = X;
            YSt = Y;
            for (int i = 0; i < MaxPeriod; i++)
            {
                XT = FunctX(X, Y);
                Y = FunctY(X, Y);
                X = XT;
                if (Math.Abs(X) >= Big || Math.Abs(Y) >= Big)
                {
                    return 0;
                }
                if (Math.Sqrt(Math.Pow(X - XSt, 2) + Math.Pow(Y - YSt, 2)) <= Eps)
                {
                    return i;
                }
            }
            return 0;
        }

        public static bool FindRoot(Func<double, double> Funct, double Left,
            double Right, double Root, double Precision, int MaxCount)
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
                    Left = Left + (Right - Left) * Precision;
                }
                
            } while (Math.Abs(Left - Right) * 1000 < Precision);

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

        private static bool FindRootR(Func<double, double> Funct,
            ref double Left, ref double Right, ref int MaxCount,
            ref double Precision, ref double Root)
        {
            double Mid;
            double FLeft, FRight, FMid;

            FLeft = Funct(Left);
            FRight = Funct(Right);

            for (int i = 0; i < MaxCount; i++)
            {
                Mid = Left - FLeft * (Right - Left) / (FRight - FLeft);
                FMid = Funct(Mid);
                if (Math.Abs(FMid) <= Precision)
                {
                    Root = Mid;
                    return true;
                }
                else
                {
                    Left = Mid;
                    FLeft = FMid;
                }
            }
            return false;
        }

		public static bool Newton(Func<double, double> Funct,
            double NearRoot, double Root, double Precision, int MaxCount)
        {
            double Dy = 0;
			double NextRoot = 0;
            int Count = 0;
	        Root = NearRoot;

			while (Math.Abs(Funct(Root)) > Precision)
			{
				Count++;
				try
				{
					 Dy = (Funct(Root + Precision) - Funct(Root - Precision)) / Precision / 2;
				}
				catch (Exception)
				{
					try
					{
						Dy = (Funct(Root) - Funct(Root - Precision)) / Precision;
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

			 NextRoot = Root - Funct(Root) / Dy;
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
			         NextRoot = (Root + NextRoot) / 2;
		        }
			} while (Math.Abs((NextRoot - Root)) * 100 < Precision);

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

			decimal current = (decimal)Math.Sqrt((double)x), previous;
			do
			{
				previous = current;
				if (previous == 0.0M) return 0;
				current = (previous + x / previous) / 2;
			}
			while (Math.Abs(previous - current) > epsilon);
			return current;
		}

		public static decimal Log(decimal value)
	    {
		    return (decimal) Math.Log((double) value);
	    }
    }
}
