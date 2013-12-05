using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ElDinamicCalc
{
	public class Proc6
	{
		private ExtArr Ex,Ey,Ez,Dx,Dy,Dz,Hx,Hy,Hz,Bx,By,Bz,ExN,EyN,EzN,DxN,DyN,DzN,HxN,HyN,HzN,BxN,ByN,BzN;

		private ExtArr Exy,Exz,Eyx,Eyz,Ezx,Ezy,Hxy,Hxz,Hyx,Hyz,Hzx,Hzy,ExyN,ExzN,EyxN,EyzN,EzxN,EzyN,HxyN,HxzN,HyxN,HyzN,HzxN,HzyN;

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
		}

		public void CreateFields()
		{
			Ez = new ExtArr(SizeX + 2, SizeY + 2, 0, 0, 0, 0, -1, -1);
			EzN = new ExtArr(SizeX + 2, SizeY + 2, 0, 0, 0, 0, -1, -1);
			Ex = new ExtArr(SizeX + 2, SizeY + 2, 0, 0, 0, 0, -1, -1);
			ExN = new ExtArr(SizeX + 2, SizeY + 2, 0, 0, 0, 0, -1, -1);
			Ey = new ExtArr(SizeX + 2, SizeY + 2, 0, 0, 0, 0, -1, -1);
			EyN = new ExtArr(SizeX + 2, SizeY + 2, 0, 0, 0, 0, -1, -1);
			Dz = new ExtArr(SizeX + 2, SizeY + 2, 0, 0, 0, 0, -1, -1);
			DzN = new ExtArr(SizeX + 2, SizeY + 2, 0, 0, 0, 0, -1, -1);
			Dx = new ExtArr(SizeX + 2, SizeY + 2, 0, 0, 0, 0, -1, -1);
			DxN = new ExtArr(SizeX + 2, SizeY + 2, 0, 0, 0, 0, -1, -1);
			Dy = new ExtArr(SizeX + 2, SizeY + 2, 0, 0, 0, 0, -1, -1);
			DyN = new ExtArr(SizeX + 2, SizeY + 2, 0, 0, 0, 0, -1, -1);
			Bz = new ExtArr(SizeX + 2, SizeY + 2, 0, 0, 0, 0, -1, -1);
			BzN = new ExtArr(SizeX + 2, SizeY + 2, 0, 0, 0, 0, -1, -1);
			Bx = new ExtArr(SizeX + 2, SizeY + 2, 0, 0, 0, 0, -1, -1);
			BxN = new ExtArr(SizeX + 2, SizeY + 2, 0, 0, 0, 0, -1, -1);
			By = new ExtArr(SizeX + 2, SizeY + 2, 0, 0, 0, 0, -1, -1);
			ByN = new ExtArr(SizeX + 2, SizeY + 2, 0, 0, 0, 0, -1, -1);
			Hz = new ExtArr(SizeX + 2, SizeY + 2, 0, 0, 0, 0, -1, -1);
			HzN = new ExtArr(SizeX + 2, SizeY + 2, 0, 0, 0, 0, -1, -1);
			Hx = new ExtArr(SizeX + 2, SizeY + 2, 0, 0, 0, 0, -1, -1);
			HxN = new ExtArr(SizeX + 2, SizeY + 2, 0, 0, 0, 0, -1, -1);
			Hy = new ExtArr(SizeX + 2, SizeY + 2, 0, 0, 0, 0, -1, -1);
			HyN = new ExtArr(SizeX + 2, SizeY + 2, 0, 0, 0, 0, -1, -1);

			Exy = new ExtArr(SizeX + 2 * BoundWidth, SizeY + 2 * BoundWidth, BoundWidth, BoundWidth, SizeX, SizeY, -BoundWidth,
				-BoundWidth);
			Exz = new ExtArr(SizeX + 2 * BoundWidth, SizeY + 2 * BoundWidth, BoundWidth, BoundWidth, SizeX, SizeY, -BoundWidth,
				-BoundWidth);
			Eyx = new ExtArr(SizeX + 2 * BoundWidth, SizeY + 2 * BoundWidth, BoundWidth, BoundWidth, SizeX, SizeY, -BoundWidth,
				-BoundWidth);
			Eyz = new ExtArr(SizeX + 2 * BoundWidth, SizeY + 2 * BoundWidth, BoundWidth, BoundWidth, SizeX, SizeY, -BoundWidth,
				-BoundWidth);
			Ezx = new ExtArr(SizeX + 2 * BoundWidth, SizeY + 2 * BoundWidth, BoundWidth, BoundWidth, SizeX, SizeY, -BoundWidth,
				-BoundWidth);
			Ezy = new ExtArr(SizeX + 2 * BoundWidth, SizeY + 2 * BoundWidth, BoundWidth, BoundWidth, SizeX, SizeY, -BoundWidth,
				-BoundWidth);
			Hxy = new ExtArr(SizeX + 2 * BoundWidth, SizeY + 2 * BoundWidth, BoundWidth, BoundWidth, SizeX, SizeY, -BoundWidth,
				-BoundWidth);
			Hxz = new ExtArr(SizeX + 2 * BoundWidth, SizeY + 2 * BoundWidth, BoundWidth, BoundWidth, SizeX, SizeY, -BoundWidth,
				-BoundWidth);
			Hyx = new ExtArr(SizeX + 2 * BoundWidth, SizeY + 2 * BoundWidth, BoundWidth, BoundWidth, SizeX, SizeY, -BoundWidth,
				-BoundWidth);
			Hyz = new ExtArr(SizeX + 2 * BoundWidth, SizeY + 2 * BoundWidth, BoundWidth, BoundWidth, SizeX, SizeY, -BoundWidth,
				-BoundWidth);
			Hzx = new ExtArr(SizeX + 2 * BoundWidth, SizeY + 2 * BoundWidth, BoundWidth, BoundWidth, SizeX, SizeY, -BoundWidth,
				-BoundWidth);
			Hzy = new ExtArr(SizeX + 2 * BoundWidth, SizeY + 2 * BoundWidth, BoundWidth, BoundWidth, SizeX, SizeY, -BoundWidth,
				-BoundWidth);
			ExyN = new ExtArr(SizeX + 2 * BoundWidth, SizeY + 2 * BoundWidth, BoundWidth, BoundWidth, SizeX, SizeY, -BoundWidth,
				-BoundWidth);
			ExzN = new ExtArr(SizeX + 2 * BoundWidth, SizeY + 2 * BoundWidth, BoundWidth, BoundWidth, SizeX, SizeY, -BoundWidth,
				-BoundWidth);
			EyxN = new ExtArr(SizeX + 2 * BoundWidth, SizeY + 2 * BoundWidth, BoundWidth, BoundWidth, SizeX, SizeY, -BoundWidth,
				-BoundWidth);
			EyzN = new ExtArr(SizeX + 2 * BoundWidth, SizeY + 2 * BoundWidth, BoundWidth, BoundWidth, SizeX, SizeY, -BoundWidth,
				-BoundWidth);
			EzxN = new ExtArr(SizeX + 2 * BoundWidth, SizeY + 2 * BoundWidth, BoundWidth, BoundWidth, SizeX, SizeY, -BoundWidth,
				-BoundWidth);
			EzyN = new ExtArr(SizeX + 2 * BoundWidth, SizeY + 2 * BoundWidth, BoundWidth, BoundWidth, SizeX, SizeY, -BoundWidth,
				-BoundWidth);
			HxyN = new ExtArr(SizeX + 2 * BoundWidth, SizeY + 2 * BoundWidth, BoundWidth, BoundWidth, SizeX, SizeY, -BoundWidth,
				-BoundWidth);
			HxzN = new ExtArr(SizeX + 2 * BoundWidth, SizeY + 2 * BoundWidth, BoundWidth, BoundWidth, SizeX, SizeY, -BoundWidth,
				-BoundWidth);
			HyxN = new ExtArr(SizeX + 2 * BoundWidth, SizeY + 2 * BoundWidth, BoundWidth, BoundWidth, SizeX, SizeY, -BoundWidth,
				-BoundWidth);
			HyzN = new ExtArr(SizeX + 2 * BoundWidth, SizeY + 2 * BoundWidth, BoundWidth, BoundWidth, SizeX, SizeY, -BoundWidth,
				-BoundWidth);
			HzxN = new ExtArr(SizeX + 2 * BoundWidth, SizeY + 2 * BoundWidth, BoundWidth, BoundWidth, SizeX, SizeY, -BoundWidth,
				-BoundWidth);
			HzyN = new ExtArr(SizeX + 2 * BoundWidth, SizeY + 2 * BoundWidth, BoundWidth, BoundWidth, SizeX, SizeY, -BoundWidth,
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
				return Ex[i, j];
			return Exy[i, j] + Exz[i, j];
		}

		public double GetEy(int i, int j)
		{
			if ((i >= 0) && (i < SizeX) && (j >= 0) && (j < SizeY))
				return Ey[i, j];
			return Eyx[i, j] + Eyz[i, j];
		}

		public double GetEz(int i, int j)
		{
			if ((i >= 0) && (i < SizeX) && (j >= 0) && (j < SizeY))
				return Ez[i, j];
			return Ezx[i, j] + Ezy[i, j];
		}


		public double GetHx(int i, int j)
		{
			if ((i >= 0) && (i < SizeX) && (j >= 0) && (j < SizeY))
				return Hx[i, j];
			return Hxy[i, j] + Hxz[i, j];
		}

		public double GetHy(int i, int j)
		{
			if ((i >= 0) && (i < SizeX) && (j >= 0) && (j < SizeY))
				return Hy[i, j];
			return Hyx[i, j] + Hyz[i, j];
		}

		public double GetHz(int i, int j)
		{
			if ((i >= 0) && (i < SizeX) && (j >= 0) && (j < SizeY))
				return Hz[i, j];
			return Hzx[i, j] + Hzy[i, j];
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
					  * PhisCnst.Eps0 * Math.Sqrt(Ez[i, j] / PhisCnst.Ez0);
			DzN[i, j] = Dz[i, j] + Common6.DtDivDx * (Hy[i + 1, j] - Hy[i - 1, j])
						- Common6.DtDivDy * (Hx[i, j + 1] - Hx[i, j - 1]);
			if (Eps != 0)
				EzN[i, j] = DzN[i, j] / Eps;
			else
				EzN[i, j] = 0;
		}

	    public void ElectrTM(int i, int j)
	    {
	    }

		public void MagnTE(int i, int j)
		{
			BxN[i, j] = Bx[i, j] - Common6.DtDivDy * (Ez[i, j + 1] - Ez[i, j - 1]);
			ByN[i, j] = By[i, j] + Common6.DtDivDx * (Ez[i + 1, j] - Ez[i - 1, j]);
			HxN[i, j] = BxN[i, j] / PhisCnst.Mu0;
			HyN[i, j] = ByN[i, j] / PhisCnst.Mu0;
		}

        public void MagnTM(int i, int j)
        {
          
        }

		public void MetallABC()
		{
			for (int i = 0; i < SizeX; i++)
			{
				//верхняя стенка
				Ez[i, 0] = 0;
				Dz[i, 0] = 0;
				Ez[i, -1] = -Ez[i, 1];
				Dz[i, -1] = -Dz[i, 1];

				//нижняя стенка
				Ez[i, SizeY - 1] = 0;
				Dz[i, SizeY - 1] = 0;
				Ez[i, SizeY] = -Ez[i, SizeY - 2];
				Dz[i, SizeY] = -Dz[i, SizeY - 2];
			}

			for (int j = 0; j < SizeY; j++)
			{
				//левая стенка
				Ez[0, j] = 0;
				Dz[0, j] = 0;
				Ez[-1, j] = -Ez[1, j];
				Dz[-1, j] = -Dz[1, j];

				//правая стенка
				Ez[SizeX - 1, j] = 0;
				Dz[SizeX - 1, j] = 0;
				Ez[SizeX, j] = -Ez[SizeX - 2, j];
				Dz[SizeX, j] = -Dz[SizeX - 2, j];
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
								EzxN[i, j] = Ezx[i, j] * Common6.SigmaXCoeffs[i, j]
											 + Common6.OneDivSigmaX[i, j] * (GetHy(i + 1, j) - GetHy(i - 1, j))
											 * (1 - Common6.SigmaXCoeffs[i, j]);
								EzyN[i, j] = Ezy[i, j] * Common6.SigmaXCoeffs[i, j] - Common6.OneDivSigmaY[i, j]
											 * (GetHx(i, j + 1) - GetHx(i, j - 1)) * (1 - Common6.SigmaYCoeffs[i, j]);
								break;

							case TModeType.mtTM:
								ExyN[i, j] = Exy[i, j] * Math.Log(-GetSigmaY(i, j)
																* Common6.DelT / PhisCnst.Eps0)
											 + 1 / Common6.DelY / GetSigmaY(i, j) * (GetHz(i, j + 1)
																			   - GetHz(i, j - 1)) * (1 - Math.Log(-GetSigmaY(i, j)
																												* Common6.DelT / PhisCnst.Eps0));
								ExzN[i, j] = Exz[i, j] * Math.Log(-GetSigmaZ(0, 0)
																* Common6.DelT / PhisCnst.Eps0);
								EyxN[i, j] = Eyx[i, j] * Math.Log(-GetSigmaX(i, j)
																* Common6.DelT / PhisCnst.Eps0) - 1 / Common6.DelX
											 / GetSigmaX(i, j) * (GetHz(i + 1, j) - GetHz(i - 1, j))
											 * (1 - Math.Log(-GetSigmaX(i, j) * Common6.DelT / PhisCnst.Eps0));
								EyzN[i, j] = Eyz[i, j] * Math.Log(-GetSigmaZ(0, 0) * Common6.DelT / PhisCnst.Eps0);
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
								HxyN[i, j] = Hxy[i, j] * Common6.SigmaYSCoeffs[i, j]
											 - Common6.OneDivSigmaYS[i, j]
											 * (GetEz(i, j + 1) - GetEz(i, j - 1))
											 * (1 - Common6.SigmaYSCoeffs[i, j]);
								HxzN[i, j] = Hxz[i, j] * Common6.SigmaZSCoeffs[i, j];
								HyxN[i, j] = Hyx[i, j] * Common6.SigmaXSCoeffs[i, j]
											 + Common6.OneDivSigmaXS[i, j]
											 * (GetEz(i + 1, j) - GetEz(i - 1, j))
											 * (1 - Common6.SigmaXSCoeffs[i, j]);
								HyzN[i, j] = Hyz[i, j] * Common6.SigmaZSCoeffs[i, j];
								break;

							case TModeType.mtTM:
								HzxN[i, j] = Hzx[i, j] * Math.Log(-GetSigmaXS(i, j)
									* Common6.DelT / PhisCnst.Mu0) - 1 / Common6.DelX / GetSigmaXS(i, j)
									* (GetEy(i + 1, j) - GetEy(i - 1, j))
									* (1 - Math.Log(-GetSigmaXS(i, j) * Common6.DelT / PhisCnst.Mu0));
								HzyN[i, j] = Hzy[i, j] * Math.Log(-GetSigmaYS(i, j) * Common6.DelT
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
					Ex[i, -1] = GetEx(i, -1);
					Ey[i, -1] = GetEy(i, -1);
					Ez[i, -1] = GetEz(i, -1);
					Ex[i, Common6.SizeY] = GetEx(i, Common6.SizeY);
					Ey[i, Common6.SizeY] = GetEy(i, Common6.SizeY);
					Ez[i, Common6.SizeY] = GetEz(i, Common6.SizeY);
				}
				for (int j = -1; j <= SizeY; j++)
				{
					Ex[-1, j] = GetEx(-1, j);
					Ey[-1, j] = GetEy(-1, j);
					Ez[-1, j] = GetEz(-1, j);
					Ex[SizeX, j] = GetEx(SizeX, j);
					Ey[SizeX, j] = GetEy(SizeX, j);
					Ez[SizeX, j] = GetEz(SizeX, j);
				}
			}
			else
			{
				AbsMagn();
				for (int i = -1; i <= SizeX; i++)
				{
					Hx[i, -1] = GetHx(i, -1);
					Hy[i, -1] = GetHy(i, -1);
					Hz[i, -1] = GetHz(i, -1);
					Hx[i, SizeY] = GetHx(i, SizeY);
					Hy[i, SizeY] = GetHy(i, SizeY);
					Hz[i, SizeY] = GetHz(i, SizeY);
				}

				for (int j = -1; j <= SizeY; j++)
				{
					Hx[-1, j] = GetHx(-1, j);
					Hy[-1, j] = GetHy(-1, j);
					Hz[-1, j] = GetHz(-1, j);
					Hx[SizeX, j] = GetHx(SizeX, j);
					Hy[SizeX, j] = GetHy(SizeX, j);
					Hz[SizeX, j] = GetHz(SizeX, j);
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
				SwapFields(Ex, ExN);
				SwapFields(Ey, EyN);
				SwapFields(Ez, EzN);
				SwapFields(Dx, DxN);
				SwapFields(Dy, DyN);
				SwapFields(Dz, DzN);
				SwapFields(Exy, ExyN);
				SwapFields(Exz, ExzN);
				SwapFields(Eyx, EyxN);
				SwapFields(Eyz, EyzN);
				SwapFields(Ezx, EzxN);
				SwapFields(Ezy, EzyN);
			}
			else
			{
				SwapFields(Hx, HxN);
				SwapFields(Hy, HyN);
				SwapFields(Hz, HzN);
				SwapFields(Bx, BxN);
				SwapFields(By, ByN);
				SwapFields(Bz, BzN);
				SwapFields(Hxy, HxyN);
				SwapFields(Hxz, HxzN);
				SwapFields(Hyx, HyxN);
				SwapFields(Hyz, HyzN);
				SwapFields(Hzx, HzxN);
				SwapFields(Hzy, HzyN);
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
	                Int1 = Int1 + Ez[Common6.IntX, j] * Common6.IntFModeEz[0, j];
                    Int2 = Int2 + (Hy[Common6.IntX, j - 1] + Hy[Common6.IntX, j + 1]) * Common6.IntFModeEz[0, j];
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
