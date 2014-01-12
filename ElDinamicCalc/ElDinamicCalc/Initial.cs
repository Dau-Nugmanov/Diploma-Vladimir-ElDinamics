using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ElDinamicCalc
{
	public class Initial
	{
		public static void PlaneWaveTE()
		{
			for (int i = Common6.InitialX1; i < Common6.InitialX2; i++)
				for (int j = Common6.InitialY1; j < Common6.InitialY2; j++)
				{
					if ((i + j + 2)%2 == 0)
					{
						Common6.Ez[i, j] = (decimal)PhisCnst.Ez0*
										   ExtMath.Sin(ExtMath.Pi * Common6.HalfPX * (i - Common6.InitialX1) / (Common6.InitialX2 - Common6.InitialX1))
						                   *
										   ExtMath.Sin(ExtMath.Pi * Common6.HalfPY * (j - Common6.InitialY1) / (Common6.InitialY2 - Common6.InitialY1));
						Common6.Dz[i, j] =
							Common6.Ez[i, j] * (decimal)PhisCnst.Eps0 * (decimal)RegionList.Eps;
					}
					else
					{
						Common6.Hy[i, j] = (decimal)PhisCnst.Hz0
						                   *
										   ExtMath.Sin(ExtMath.Pi * Common6.HalfPX * (i - Common6.InitialX1) / (Common6.InitialX2 - Common6.InitialX1))
						                   *
										   ExtMath.Sin(ExtMath.Pi * Common6.HalfPY * (j - Common6.InitialY1) / (Common6.InitialY2 - Common6.InitialY1));
						Common6.By[i, j] = Common6.Hy[i, j] * (decimal)PhisCnst.Mu0;
					}
				}
		}

		public static void PlaneWaveTM()
		{
			for (int i = Common6.InitialX1; i < Common6.InitialX2; i++)
				for (int j = Common6.InitialY1; j < Common6.InitialY2; j++)
				{
					if ((i + j + 2)%2 == 0)
					{
						Common6.Ey[i, j] = (decimal)PhisCnst.Ez0
						                   *
										   ExtMath.Sin(ExtMath.Pi * Common6.HalfPX * (i - Common6.InitialX1) / (Common6.InitialX2 - Common6.InitialX1))
						                   *
										  ExtMath.Cos(ExtMath.Pi * Common6.HalfPY * (j - Common6.InitialY1) / (Common6.InitialY2 - Common6.InitialY1));
						Common6.Dy[i, j] = Common6.Ez[i, j] * (decimal)PhisCnst.Eps0 * (decimal)RegionList.Eps;
					}
					else
					{
						Common6.Hz[i, j] = (decimal)PhisCnst.Hz0
		  * ExtMath.Sin(ExtMath.Pi * Common6.HalfPX * (i - Common6.InitialX1) / (Common6.InitialX2 - Common6.InitialX1))
		  *ExtMath.Cos(ExtMath.Pi * Common6.HalfPY * (j - Common6.InitialY1) / (Common6.InitialY2 - Common6.InitialY1));
						Common6.Bz[i, j] = Common6.Hy[i, j] * (decimal)PhisCnst.Mu0;
					}
				}
		}

		public static void GaussTE()
		{
			for (int i = Common6.InitialX1; i < Common6.InitialX2; i++)
				for (int j = Common6.InitialY1; j < Common6.InitialY2; j++)
				{
					if ((i + j + 2)%2 == 0)
					{
						Common6.Ez[i, j] = (decimal)PhisCnst.Ez0
						                   *
										   ExtMath.Sin(ExtMath.Pi * Common6.HalfPX * (i - Common6.InitialX1) / (Common6.InitialX2 - Common6.InitialX1))
						                   *
										  ExtMath.Sin(ExtMath.Pi * Common6.HalfPY * (j - Common6.InitialY1) / (Common6.InitialY2 - Common6.InitialY1))
										   * (decimal)ExtMath.Exp(-ExtMath.Pow(Common6.ExpX * (i - (Common6.InitialX1 + Common6.InitialX2) / 2), 2)
						                             - ExtMath.Pow(Common6.ExpY*(j - (Common6.InitialY1 + Common6.InitialY2)/2), 2));
						Common6.Dz[i, j] = Common6.Ez[i, j] * (decimal)PhisCnst.Eps0 * (decimal)RegionList.Eps;
					}
					else
					{
						Common6.Hy[i, j] = (decimal)PhisCnst.Hz0
						                   *
										   ExtMath.Sin(ExtMath.Pi * Common6.HalfPX * (i - Common6.InitialX1) / (Common6.InitialX2 - Common6.InitialX1))
						                   *
										   ExtMath.Sin(ExtMath.Pi * Common6.HalfPY * (j - Common6.InitialY1) / (Common6.InitialY2 - Common6.InitialY1))
										   * (decimal)ExtMath.Exp(-ExtMath.Pow(Common6.ExpX * (i - (Common6.InitialX1 + Common6.InitialX2) / 2), 2)
						                             - ExtMath.Pow(Common6.ExpY*(j - (Common6.InitialY1 + Common6.InitialY2)/2), 2));
						Common6.By[i, j] = Common6.Hy[i, j] * (decimal)PhisCnst.Mu0;
					}
				}
		}

		public static void GaussTM()
		{
		}

		public static void WaveFromRegionList()
		{
			for (int i = 0; i < RegionList.FieldList.Count; i++)
			{
				RegionList.FieldList[i].FillEx(Common6.Ex);
				RegionList.FieldList[i].FillEy(Common6.Ey);
				RegionList.FieldList[i].FillEz(Common6.Ez);
				RegionList.FieldList[i].FillDx(Common6.Dx);
				RegionList.FieldList[i].FillDy(Common6.Dy);
				RegionList.FieldList[i].FillDz(Common6.Dz);
				RegionList.FieldList[i].FillBx(Common6.Bx);
				RegionList.FieldList[i].FillBy(Common6.By);
				RegionList.FieldList[i].FillBz(Common6.Bz);
				RegionList.FieldList[i].FillHx(Common6.Hx);
				RegionList.FieldList[i].FillHy(Common6.Hy);
				RegionList.FieldList[i].FillHz(Common6.Hz);
			}
		}

	}
}
