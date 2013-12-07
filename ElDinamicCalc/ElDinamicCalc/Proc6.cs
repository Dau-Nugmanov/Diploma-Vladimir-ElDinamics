﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ElDinamicCalc
{
	public class Proc6
	{
		private int SizeX = Common6.SizeX0;
		private int SizeY = Common6.SizeX0;
		private int BoundWidth = Common6.BoundWidth0;

		private static double SigmaX = 2 * Math.PI * PhisCnst.Eps0 / 1000;
		private static double SigmaY = 2 * Math.PI * PhisCnst.Eps0 / 1000;
		private double SigmaZ = 0;
		private double SigmaXS = SigmaX * PhisCnst.Mu0 / PhisCnst.Eps0;
		private double SigmaYS = SigmaY * PhisCnst.Mu0 / PhisCnst.Eps0;
		private double SigmaZS = 0;
		private double CoefG = Common6.G;

		public Proc6()
		{
			CreateFields();
			if (RegionList.BoundsType == TBoundsType.btAbsorb)
				SetSigmaCoeffs();
			if (Common6.IntEnable)
				SetIntMode();
		}

		public void CreateFields()
		{
			Common6.Ez = new ExtArr(SizeX + 2, SizeY + 2, 0, 0, 0, 0, -1, -1);
			Common6.EzN = new ExtArr(SizeX + 2, SizeY + 2, 0, 0, 0, 0, -1, -1);
			Common6.Ex = new ExtArr(SizeX + 2, SizeY + 2, 0, 0, 0, 0, -1, -1);
			Common6.ExN = new ExtArr(SizeX + 2, SizeY + 2, 0, 0, 0, 0, -1, -1);
			Common6.Ey = new ExtArr(SizeX + 2, SizeY + 2, 0, 0, 0, 0, -1, -1);
			Common6.EyN = new ExtArr(SizeX + 2, SizeY + 2, 0, 0, 0, 0, -1, -1);
			Common6.Dz = new ExtArr(SizeX + 2, SizeY + 2, 0, 0, 0, 0, -1, -1);
			Common6.DzN = new ExtArr(SizeX + 2, SizeY + 2, 0, 0, 0, 0, -1, -1);
			Common6.Dx = new ExtArr(SizeX + 2, SizeY + 2, 0, 0, 0, 0, -1, -1);
			Common6.DxN = new ExtArr(SizeX + 2, SizeY + 2, 0, 0, 0, 0, -1, -1);
			Common6.Dy = new ExtArr(SizeX + 2, SizeY + 2, 0, 0, 0, 0, -1, -1);
			Common6.DyN = new ExtArr(SizeX + 2, SizeY + 2, 0, 0, 0, 0, -1, -1);
			Common6.Bz = new ExtArr(SizeX + 2, SizeY + 2, 0, 0, 0, 0, -1, -1);
			Common6.BzN = new ExtArr(SizeX + 2, SizeY + 2, 0, 0, 0, 0, -1, -1);
			Common6.Bx = new ExtArr(SizeX + 2, SizeY + 2, 0, 0, 0, 0, -1, -1);
			Common6.BxN = new ExtArr(SizeX + 2, SizeY + 2, 0, 0, 0, 0, -1, -1);
			Common6.By = new ExtArr(SizeX + 2, SizeY + 2, 0, 0, 0, 0, -1, -1);
			Common6.ByN = new ExtArr(SizeX + 2, SizeY + 2, 0, 0, 0, 0, -1, -1);
			Common6.Hz = new ExtArr(SizeX + 2, SizeY + 2, 0, 0, 0, 0, -1, -1);
			Common6.HzN = new ExtArr(SizeX + 2, SizeY + 2, 0, 0, 0, 0, -1, -1);
			Common6.Hx = new ExtArr(SizeX + 2, SizeY + 2, 0, 0, 0, 0, -1, -1);
			Common6.HxN = new ExtArr(SizeX + 2, SizeY + 2, 0, 0, 0, 0, -1, -1);
			Common6.Hy = new ExtArr(SizeX + 2, SizeY + 2, 0, 0, 0, 0, -1, -1);
			Common6.HyN = new ExtArr(SizeX + 2, SizeY + 2, 0, 0, 0, 0, -1, -1);

			Common6.Exy = new ExtArr(SizeX + 2 * BoundWidth, SizeY + 2 * BoundWidth, BoundWidth, BoundWidth, SizeX, SizeY, -BoundWidth,
				-BoundWidth);
			Common6.Exz = new ExtArr(SizeX + 2 * BoundWidth, SizeY + 2 * BoundWidth, BoundWidth, BoundWidth, SizeX, SizeY, -BoundWidth,
				-BoundWidth);
			Common6.Eyx = new ExtArr(SizeX + 2 * BoundWidth, SizeY + 2 * BoundWidth, BoundWidth, BoundWidth, SizeX, SizeY, -BoundWidth,
				-BoundWidth);
			Common6.Eyz = new ExtArr(SizeX + 2 * BoundWidth, SizeY + 2 * BoundWidth, BoundWidth, BoundWidth, SizeX, SizeY, -BoundWidth,
				-BoundWidth);
			Common6.Ezx = new ExtArr(SizeX + 2 * BoundWidth, SizeY + 2 * BoundWidth, BoundWidth, BoundWidth, SizeX, SizeY, -BoundWidth,
				-BoundWidth);
			Common6.Ezy = new ExtArr(SizeX + 2 * BoundWidth, SizeY + 2 * BoundWidth, BoundWidth, BoundWidth, SizeX, SizeY, -BoundWidth,
				-BoundWidth);
			Common6.Hxy = new ExtArr(SizeX + 2 * BoundWidth, SizeY + 2 * BoundWidth, BoundWidth, BoundWidth, SizeX, SizeY, -BoundWidth,
				-BoundWidth);
			Common6.Hxz = new ExtArr(SizeX + 2 * BoundWidth, SizeY + 2 * BoundWidth, BoundWidth, BoundWidth, SizeX, SizeY, -BoundWidth,
				-BoundWidth);
			Common6.Hyx = new ExtArr(SizeX + 2 * BoundWidth, SizeY + 2 * BoundWidth, BoundWidth, BoundWidth, SizeX, SizeY, -BoundWidth,
				-BoundWidth);
			Common6.Hyz = new ExtArr(SizeX + 2 * BoundWidth, SizeY + 2 * BoundWidth, BoundWidth, BoundWidth, SizeX, SizeY, -BoundWidth,
				-BoundWidth);
			Common6.Hzx = new ExtArr(SizeX + 2 * BoundWidth, SizeY + 2 * BoundWidth, BoundWidth, BoundWidth, SizeX, SizeY, -BoundWidth,
				-BoundWidth);
			Common6.Hzy = new ExtArr(SizeX + 2 * BoundWidth, SizeY + 2 * BoundWidth, BoundWidth, BoundWidth, SizeX, SizeY, -BoundWidth,
				-BoundWidth);
			Common6.ExyN = new ExtArr(SizeX + 2 * BoundWidth, SizeY + 2 * BoundWidth, BoundWidth, BoundWidth, SizeX, SizeY, -BoundWidth,
				-BoundWidth);
			Common6.ExzN = new ExtArr(SizeX + 2 * BoundWidth, SizeY + 2 * BoundWidth, BoundWidth, BoundWidth, SizeX, SizeY, -BoundWidth,
				-BoundWidth);
			Common6.EyxN = new ExtArr(SizeX + 2 * BoundWidth, SizeY + 2 * BoundWidth, BoundWidth, BoundWidth, SizeX, SizeY, -BoundWidth,
				-BoundWidth);
			Common6.EyzN = new ExtArr(SizeX + 2 * BoundWidth, SizeY + 2 * BoundWidth, BoundWidth, BoundWidth, SizeX, SizeY, -BoundWidth,
				-BoundWidth);
			Common6.EzxN = new ExtArr(SizeX + 2 * BoundWidth, SizeY + 2 * BoundWidth, BoundWidth, BoundWidth, SizeX, SizeY, -BoundWidth,
				-BoundWidth);
			Common6.EzyN = new ExtArr(SizeX + 2 * BoundWidth, SizeY + 2 * BoundWidth, BoundWidth, BoundWidth, SizeX, SizeY, -BoundWidth,
				-BoundWidth);
			Common6.HxyN = new ExtArr(SizeX + 2 * BoundWidth, SizeY + 2 * BoundWidth, BoundWidth, BoundWidth, SizeX, SizeY, -BoundWidth,
				-BoundWidth);
			Common6.HxzN = new ExtArr(SizeX + 2 * BoundWidth, SizeY + 2 * BoundWidth, BoundWidth, BoundWidth, SizeX, SizeY, -BoundWidth,
				-BoundWidth);
			Common6.HyxN = new ExtArr(SizeX + 2 * BoundWidth, SizeY + 2 * BoundWidth, BoundWidth, BoundWidth, SizeX, SizeY, -BoundWidth,
				-BoundWidth);
			Common6.HyzN = new ExtArr(SizeX + 2 * BoundWidth, SizeY + 2 * BoundWidth, BoundWidth, BoundWidth, SizeX, SizeY, -BoundWidth,
				-BoundWidth);
			Common6.HzxN = new ExtArr(SizeX + 2 * BoundWidth, SizeY + 2 * BoundWidth, BoundWidth, BoundWidth, SizeX, SizeY, -BoundWidth,
				-BoundWidth);
			Common6.HzyN = new ExtArr(SizeX + 2 * BoundWidth, SizeY + 2 * BoundWidth, BoundWidth, BoundWidth, SizeX, SizeY, -BoundWidth,
				-BoundWidth);
		}

		//меняет местами указатели на две компоненты поля
		public void SwapFields(ExtArr field1, ExtArr field2)
		{
			var temp = field2;
			field2 = field1;
			field1 = temp;
		}

		//следующие 6 функций возращают значения компонент в точке:
		//само значение, если точка внутри системы
		//иначе - сумма значений расщепленных компонент

		public double GetEx(int i, int j)
		{
			if ((i >= 0) && (i < SizeX) && (j >= 0) && (j < SizeY))
				return Common6.Ex[i, j];
			return Common6.Exy[i, j] + Common6.Exz[i, j];
		}

		public double GetEy(int i, int j)
		{
			if ((i >= 0) && (i < SizeX) && (j >= 0) && (j < SizeY))
				return Common6.Ey[i, j];
			return Common6.Eyx[i, j] + Common6.Eyz[i, j];
		}

		public double GetEz(int i, int j)
		{
			if ((i >= 0) && (i < SizeX) && (j >= 0) && (j < SizeY))
				return Common6.Ez[i, j];
			return Common6.Ezx[i, j] + Common6.Ezy[i, j];
		}


		public double GetHx(int i, int j)
		{
			if ((i >= 0) && (i < SizeX) && (j >= 0) && (j < SizeY))
				return Common6.Hx[i, j];
			return Common6.Hxy[i, j] + Common6.Hxz[i, j];
		}

		public double GetHy(int i, int j)
		{
			if ((i >= 0) && (i < SizeX) && (j >= 0) && (j < SizeY))
				return Common6.Hy[i, j];
			return Common6.Hyx[i, j] + Common6.Hyz[i, j];
		}

		public double GetHz(int i, int j)
		{
			if ((i >= 0) && (i < SizeX) && (j >= 0) && (j < SizeY))
				return Common6.Hz[i, j];
			return Common6.Hzx[i, j] + Common6.Hzy[i, j];
		}

		//следующие 6 функций возращают значения параметров Sigma в точке
		//учитывается расстояние до границы ситемы

		public double GetSigmaX(int i, int j)
		{

			if (i < 0)
				return SigmaX * ExtMath.Degree(CoefG, -i + 1);
			if (i >= SizeX)
				return SigmaX * ExtMath.Degree(CoefG, i - SizeX);
			return SigmaX;
		}

		public double GetSigmaY(int i, int j)
		{
			if (j < 0)
				return SigmaY * ExtMath.Degree(CoefG, -j + 1);
			if (j >= SizeY)
				return SigmaY * ExtMath.Degree(CoefG, j - SizeY);
			return SigmaY;
		}

		public double GetSigmaZ(int i, int j)
		{
			return 0;
		}

		public double GetSigmaXS(int i, int j)
		{
			return GetSigmaX(i, j) * PhisCnst.MuDivEps;
		}

		public double GetSigmaYS(int i, int j)
		{
			return GetSigmaY(i, j) * PhisCnst.MuDivEps;
		}

		public double GetSigmaZS(int i, int j)
		{
			return GetSigmaZ(i, j) * PhisCnst.MuDivEps;
		}


		public void ElectrTE(int i, int j)
		{
			var Eps = RegionList.EpsField[i, j] * PhisCnst.Eps0 + RegionList.Eps2Field[i, j]
					  * PhisCnst.Eps0 * Math.Sqrt(Common6.Ez[i, j] / PhisCnst.Ez0);
			Common6.DzN[i, j] = Common6.Dz[i, j] + Common6.DtDivDx * (Common6.Hy[i + 1, j] - Common6.Hy[i - 1, j])
						- Common6.DtDivDy * (Common6.Hx[i, j + 1] - Common6.Hx[i, j - 1]);
			if (Eps != 0)
				Common6.EzN[i, j] = Common6.DzN[i, j] / Eps;
			else
				Common6.EzN[i, j] = 0;
		}

	    public void ElectrTM(int i, int j)
	    {
	    }

		public void MagnTE(int i, int j)
		{
			Common6.BxN[i, j] = Common6.Bx[i, j] - Common6.DtDivDy * (Common6.Ez[i, j + 1] - Common6.Ez[i, j - 1]);
			Common6.ByN[i, j] = Common6.By[i, j] + Common6.DtDivDx * (Common6.Ez[i + 1, j] - Common6.Ez[i - 1, j]);
			Common6.HxN[i, j] = Common6.BxN[i, j] / PhisCnst.Mu0;
			Common6.HyN[i, j] = Common6.ByN[i, j] / PhisCnst.Mu0;
		}

        public void MagnTM(int i, int j)
        {
          
        }

		public void MetallABC()
		{
			for (int i = 0; i < SizeX; i++)
			{
				//верхняя стенка
				Common6.Ez[i, 0] = 0;
				Common6.Dz[i, 0] = 0;
				Common6.Ez[i, -1] = -Common6.Ez[i, 1];
				Common6.Dz[i, -1] = -Common6.Dz[i, 1];

				//нижняя стенка
				Common6.Ez[i, SizeY - 1] = 0;
				Common6.Dz[i, SizeY - 1] = 0;
				Common6.Ez[i, SizeY] = -Common6.Ez[i, SizeY - 2];
				Common6.Dz[i, SizeY] = -Common6.Dz[i, SizeY - 2];
			}

			for (int j = 0; j < SizeY; j++)
			{
				//левая стенка
				Common6.Ez[0, j] = 0;
				Common6.Dz[0, j] = 0;
				Common6.Ez[-1, j] = -Common6.Ez[1, j];
				Common6.Dz[-1, j] = -Common6.Dz[1, j];

				//правая стенка
				Common6.Ez[SizeX - 1, j] = 0;
				Common6.Dz[SizeX - 1, j] = 0;
				Common6.Ez[SizeX, j] = -Common6.Ez[SizeX - 2, j];
				Common6.Dz[SizeX, j] = -Common6.Dz[SizeX - 2, j];
			}
		}

		public void AbsElectr()
		{
			for (int i = -Common6.BoundWidth; i < SizeX + Common6.BoundWidth; i++)
				for (int j = -Common6.BoundWidth; j < SizeY + Common6.BoundWidth; j++)
				{
					if ((i < 0) || (i >= SizeX) || (j < 0) || (j >= SizeY))
					{
						switch (Common6.ModeType)
						{
							case TModeType.mtTE:
								Common6.EzxN[i, j] = Common6.Ezx[i, j] * Common6.SigmaXCoeffs[i, j]
											 + Common6.OneDivSigmaX[i, j] * (GetHy(i + 1, j) - GetHy(i - 1, j))
											 * (1 - Common6.SigmaXCoeffs[i, j]);
								Common6.EzyN[i, j] = Common6.Ezy[i, j] * Common6.SigmaXCoeffs[i, j] - Common6.OneDivSigmaY[i, j]
											 * (GetHx(i, j + 1) - GetHx(i, j - 1)) * (1 - Common6.SigmaYCoeffs[i, j]);
								break;

							case TModeType.mtTM:
								Common6.ExyN[i, j] = Common6.Exy[i, j] * Math.Log(-GetSigmaY(i, j)
																* Common6.DelT / PhisCnst.Eps0)
											 + 1 / Common6.DelY / GetSigmaY(i, j) * (GetHz(i, j + 1)
																			   - GetHz(i, j - 1)) * (1 - Math.Log(-GetSigmaY(i, j)
																												* Common6.DelT / PhisCnst.Eps0));
								Common6.ExzN[i, j] = Common6.Exz[i, j] * Math.Log(-GetSigmaZ(0, 0)
																* Common6.DelT / PhisCnst.Eps0);
								Common6.EyxN[i, j] = Common6.Eyx[i, j] * Math.Log(-GetSigmaX(i, j)
																* Common6.DelT / PhisCnst.Eps0) - 1 / Common6.DelX
											 / GetSigmaX(i, j) * (GetHz(i + 1, j) - GetHz(i - 1, j))
											 * (1 - Math.Log(-GetSigmaX(i, j) * Common6.DelT / PhisCnst.Eps0));
								Common6.EyzN[i, j] = Common6.Eyz[i, j] * Math.Log(-GetSigmaZ(0, 0) * Common6.DelT / PhisCnst.Eps0);
								break;
						}
					}
				}
		}

		//расчет магнитных расщепленных компонент
		public void AbsMagn()
		{
			for (int i = -Common6.BoundWidth; i < SizeX + Common6.BoundWidth; i++)
				for (int j = -Common6.BoundWidth; j < SizeY + Common6.BoundWidth; j++)
				{
					if ((i < 0) || (i >= SizeX) || (j < 0) || (j >= SizeY))
					{
						switch (Common6.ModeType)
						{
							case TModeType.mtTE:
								Common6.HxyN[i, j] = Common6.Hxy[i, j] * Common6.SigmaYSCoeffs[i, j]
											 - Common6.OneDivSigmaYS[i, j]
											 * (GetEz(i, j + 1) - GetEz(i, j - 1))
											 * (1 - Common6.SigmaYSCoeffs[i, j]);
								Common6.HxzN[i, j] = Common6.Hxz[i, j] * Common6.SigmaZSCoeffs[i, j];
								Common6.HyxN[i, j] = Common6.Hyx[i, j] * Common6.SigmaXSCoeffs[i, j]
											 + Common6.OneDivSigmaXS[i, j]
											 * (GetEz(i + 1, j) - GetEz(i - 1, j))
											 * (1 - Common6.SigmaXSCoeffs[i, j]);
								Common6.HyzN[i, j] = Common6.Hyz[i, j] * Common6.SigmaZSCoeffs[i, j];
								break;

							case TModeType.mtTM:
								Common6.HzxN[i, j] = Common6.Hzx[i, j] * Math.Log(-GetSigmaXS(i, j)
									* Common6.DelT / PhisCnst.Mu0) - 1 / Common6.DelX / GetSigmaXS(i, j)
									* (GetEy(i + 1, j) - GetEy(i - 1, j))
									* (1 - Math.Log(-GetSigmaXS(i, j) * Common6.DelT / PhisCnst.Mu0));
								Common6.HzyN[i, j] = Common6.Hzy[i, j] * Math.Log(-GetSigmaYS(i, j) * Common6.DelT
									/ PhisCnst.Mu0) + 1 / Common6.DelY / GetSigmaYS(i, j)
									* (GetEx(i, j + 1) - GetEx(i, j - 1))
									* (1 - Math.Log(-GetSigmaYS(i, j) * Common6.DelT / PhisCnst.Mu0));
								break;
						}
					}
				}

		}

		//граничные условия - поглощающие слои
		//перешагивание во времени
		public void AbsLayersABC()
		{
			if ((Common6.Tn + 2) % 2 == 0)
			{
				AbsElectr();

				for (int i = -1; i <= SizeX; i++)
				{
					Common6.Ex[i, -1] = GetEx(i, -1);
					Common6.Ey[i, -1] = GetEy(i, -1);
					Common6.Ez[i, -1] = GetEz(i, -1);
					Common6.Ex[i, Common6.SizeY] = GetEx(i, Common6.SizeY);
					Common6.Ey[i, Common6.SizeY] = GetEy(i, Common6.SizeY);
					Common6.Ez[i, Common6.SizeY] = GetEz(i, Common6.SizeY);
				}
				for (int j = -1; j <= SizeY; j++)
				{
					Common6.Ex[-1, j] = GetEx(-1, j);
					Common6.Ey[-1, j] = GetEy(-1, j);
					Common6.Ez[-1, j] = GetEz(-1, j);
					Common6.Ex[SizeX, j] = GetEx(SizeX, j);
					Common6.Ey[SizeX, j] = GetEy(SizeX, j);
					Common6.Ez[SizeX, j] = GetEz(SizeX, j);
				}
			}
			else
			{
				AbsMagn();
				for (int i = -1; i <= SizeX; i++)
				{
					Common6.Hx[i, -1] = GetHx(i, -1);
					Common6.Hy[i, -1] = GetHy(i, -1);
					Common6.Hz[i, -1] = GetHz(i, -1);
					Common6.Hx[i, SizeY] = GetHx(i, SizeY);
					Common6.Hy[i, SizeY] = GetHy(i, SizeY);
					Common6.Hz[i, SizeY] = GetHz(i, SizeY);
				}

				for (int j = -1; j <= SizeY; j++)
				{
					Common6.Hx[-1, j] = GetHx(-1, j);
					Common6.Hy[-1, j] = GetHy(-1, j);
					Common6.Hz[-1, j] = GetHz(-1, j);
					Common6.Hx[SizeX, j] = GetHx(SizeX, j);
					Common6.Hy[SizeX, j] = GetHy(SizeX, j);
					Common6.Hz[SizeX, j] = GetHz(SizeX, j);
				}
			}
		}

		//переход к следующему шагу
		public void Next()
		{
			//учет граничных условий
			switch (RegionList.BoundsType)
			{
				case TBoundsType.btMetall:
					MetallABC();
					break;
				case TBoundsType.btAbsorb:
					AbsLayersABC();
					break;

			}

			//замена массивов со старыми значениями на массивы с новыми
			//значениями с учетом перешагивания во времени
			if ((Common6.Tn + 2) % 2 == 0)
			{
				SwapFields(Common6.Ex, Common6.ExN);
				SwapFields(Common6.Ey, Common6.EyN);
				SwapFields(Common6.Ez, Common6.EzN);
				SwapFields(Common6.Dx, Common6.DxN);
				SwapFields(Common6.Dy, Common6.DyN);
				SwapFields(Common6.Dz, Common6.DzN);
				SwapFields(Common6.Exy, Common6.ExyN);
				SwapFields(Common6.Exz, Common6.ExzN);
				SwapFields(Common6.Eyx, Common6.EyxN);
				SwapFields(Common6.Eyz, Common6.EyzN);
				SwapFields(Common6.Ezx, Common6.EzxN);
				SwapFields(Common6.Ezy, Common6.EzyN);
			}
			else
			{
				SwapFields(Common6.Hx, Common6.HxN);
				SwapFields(Common6.Hy, Common6.HyN);
				SwapFields(Common6.Hz, Common6.HzN);
				SwapFields(Common6.Bx, Common6.BxN);
				SwapFields(Common6.By, Common6.ByN);
				SwapFields(Common6.Bz, Common6.BzN);
				SwapFields(Common6.Hxy, Common6.HxyN);
				SwapFields(Common6.Hxz, Common6.HxzN);
				SwapFields(Common6.Hyx, Common6.HyxN);
				SwapFields(Common6.Hyz, Common6.HyzN);
				SwapFields(Common6.Hzx, Common6.HzxN);
				SwapFields(Common6.Hzy, Common6.HzyN);
			}
		}

		public void SetSigmaCoeffs()
		{
			Common6.SigmaXCoeffs = new ExtArr(SizeX + 2 * BoundWidth,
				SizeY + 2 * BoundWidth, BoundWidth, BoundWidth, SizeX, SizeY,
				-BoundWidth, -BoundWidth);
			Common6.SigmaYCoeffs = new ExtArr(SizeX + 2 * BoundWidth,
				SizeY + 2 * BoundWidth, BoundWidth, BoundWidth, SizeX, SizeY,
				-BoundWidth, -BoundWidth);
			Common6.SigmaZCoeffs = new ExtArr(SizeX + 2 * BoundWidth,
				SizeY + 2 * BoundWidth, BoundWidth, BoundWidth, SizeX, SizeY,
				-BoundWidth, -BoundWidth);

			Common6.SigmaXSCoeffs = new ExtArr(SizeX + 2 * BoundWidth,
				SizeY + 2 * BoundWidth, BoundWidth, BoundWidth, SizeX, SizeY,
				-BoundWidth, -BoundWidth);
			Common6.SigmaYSCoeffs = new ExtArr(SizeX + 2 * BoundWidth,
				SizeY + 2 * BoundWidth, BoundWidth, BoundWidth, SizeX, SizeY,
				-BoundWidth, -BoundWidth);
			Common6.SigmaZSCoeffs = new ExtArr(SizeX + 2 * BoundWidth,
				SizeY + 2 * BoundWidth, BoundWidth, BoundWidth, SizeX, SizeY,
				-BoundWidth, -BoundWidth);

			Common6.OneDivSigmaX = new ExtArr(SizeX + 2 * BoundWidth,
				SizeY + 2 * BoundWidth, BoundWidth, BoundWidth, SizeX, SizeY,
				-BoundWidth, -BoundWidth);
			Common6.OneDivSigmaY = new ExtArr(SizeX + 2 * BoundWidth,
				SizeY + 2 * BoundWidth, BoundWidth, BoundWidth, SizeX, SizeY,
				-BoundWidth, -BoundWidth);

			Common6.OneDivSigmaXS = new ExtArr(SizeX + 2 * BoundWidth,
				SizeY + 2 * BoundWidth, BoundWidth, BoundWidth, SizeX, SizeY,
				-BoundWidth, -BoundWidth);
			Common6.OneDivSigmaYS = new ExtArr(SizeX + 2 * BoundWidth,
				SizeY + 2 * BoundWidth, BoundWidth, BoundWidth, SizeX, SizeY,
				-BoundWidth, -BoundWidth);

			for (int i = -BoundWidth; i < SizeX + BoundWidth; i++)
				for (int j = -BoundWidth; j < SizeY + BoundWidth; j++)
				{
					if ((i < 0) || (i >= SizeX) || (j < 0) || (j >= SizeY))
					{
						Common6.SigmaXCoeffs[i, j] = Math.Log(-GetSigmaX(i, j) / PhisCnst.Eps0 
							* Common6.DelT);
						Common6.SigmaYCoeffs[i, j] = Math.Log(-GetSigmaY(i, j)  / PhisCnst.Eps0 
							* Common6.DelT);
						Common6.SigmaXSCoeffs[i, j] = Math.Log(-GetSigmaXS(i, j) / PhisCnst.Mu0 
							* Common6.DelT);
						Common6.SigmaYSCoeffs[i, j] = Math.Log(-GetSigmaYS(i, j) / PhisCnst.Mu0 
							*Common6.DelT);
						Common6.OneDivSigmaX[i, j] = 1 / Common6.DelX / GetSigmaX(i, j);
						Common6.OneDivSigmaY[i, j] = 1 / Common6.DelY / GetSigmaY(i, j);
						Common6.OneDivSigmaXS[i, j] = 1 / Common6.DelX / GetSigmaXS(i, j);
						Common6.OneDivSigmaYS[i, j] = 1 / Common6.DelY / GetSigmaYS(i, j);
					}
				}
		}

		public void FreeSigmaCoeffs()
		{
			Common6.SigmaXCoeffs = null;
			Common6.SigmaYCoeffs = null;
			Common6.SigmaZCoeffs = null;
			Common6.SigmaXSCoeffs = null;
			Common6.SigmaYSCoeffs = null;
			Common6.SigmaZSCoeffs = null;
			Common6.OneDivSigmaX = null;
			Common6.OneDivSigmaY = null;
			Common6.OneDivSigmaXS = null;
			Common6.OneDivSigmaYS = null;
		}

		public void SetIntMode()
		{
			Common6.IntFModeEz = new ExtArr(1, SizeY, 0, 0, 0, 0, 0, 0);
              Common6.IntFModeHy = new ExtArr(1, SizeY, 0, 0, 0, 0, 0, 0);
              int Number = -1;
              int Count = 0;
			while (Number < Common6.SelfModeNumber)
			{
			    if ((RegionList.FieldList[Count].FieldType == TInitialFieldType.ftRectSelf)
			        || (RegionList.FieldList[Count].FieldType == TInitialFieldType.ftRectSelf2))
			    {
                    Number++;
                    Count++;
			    }
			}
 
          RegionList.FieldList[Number].FillEzMax(Common6.IntFModeEz);
          RegionList.FieldList[Number].FillHyMax(Common6.IntFModeHy);
          Common6.BettaX = RegionList.FieldList[Number].BettaX;
          Common6.BettaY = RegionList.FieldList[Number].BettaY;
		}

	    public double CalcIntegral(bool Forw)
	    {
	        int j, One;
	        double Int1, Int2, Coef;
	        One = 0;
            Int1 = 0;
	        Int2 = 0;

            //todo: Разобраться с Ord
            //One = Ord(Forw) * 2 - 1;
            Coef = Common6.BettaY / Common6.BettaX / PhisCnst.Z0;

	        for (j = 1; j < SizeY - 2; j++)
	        {
	            if ((Common6.IntX + j + 2)%2 == 0)
	            {
					Int1 = Int1 + Common6.Ez[Common6.IntX, j] * Common6.IntFModeEz[0, j];
					Int2 = Int2 + (Common6.Hy[Common6.IntX, j - 1] + Common6.Hy[Common6.IntX, j + 1]) * Common6.IntFModeEz[0, j];
	            }
	        }
	        return (One*Int1*Coef + Int2*0.5); //{* DelY};
	    }

	    public void AddValues()
	    {
            //todo: AddValues
	    }

	    public void AddIntValues()
	    {
            //todo: AddIntValues
            //Common6.IntFPoints.Add(Common6.Tn, CalcIntegral(true));
            //Common6.IntBPoints.Add(Common6.Tn, CalcIntegral(false));
            //Common6.LastAddedI++;
	    }
	}
}
