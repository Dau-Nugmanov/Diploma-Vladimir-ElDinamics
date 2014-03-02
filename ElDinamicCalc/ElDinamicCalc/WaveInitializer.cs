namespace ElDinamicCalc
{
	public class WaveInitializer
	{
		public static void PlaneWaveTE()
		{
			for (int i = CommonParams.InitialX1; i < CommonParams.InitialX2; i++)
				for (int j = CommonParams.InitialY1; j < CommonParams.InitialY2; j++)
				{
					if ((i + j + 2)%2 == 0)
					{
						CommonParams.Ez[i, j] = PhisicalConstants.Ez0*
						                   ExtMath.Sin(ExtMath.Pi*CommonParams.HalfPX*(i - CommonParams.InitialX1)/
						                               (CommonParams.InitialX2 - CommonParams.InitialX1))
						                   *
						                   ExtMath.Sin(ExtMath.Pi*CommonParams.HalfPY*(j - CommonParams.InitialY1)/
						                               (CommonParams.InitialY2 - CommonParams.InitialY1));
						CommonParams.Dz[i, j] =
							CommonParams.Ez[i, j]*PhisicalConstants.Eps0*RegionList.Eps;
					}
					else
					{
						CommonParams.Hy[i, j] = PhisicalConstants.Hz0
						                   *
						                   ExtMath.Sin(ExtMath.Pi*CommonParams.HalfPX*(i - CommonParams.InitialX1)/
						                               (CommonParams.InitialX2 - CommonParams.InitialX1))
						                   *
						                   ExtMath.Sin(ExtMath.Pi*CommonParams.HalfPY*(j - CommonParams.InitialY1)/
						                               (CommonParams.InitialY2 - CommonParams.InitialY1));
						CommonParams.By[i, j] = CommonParams.Hy[i, j]*PhisicalConstants.Mu0;
					}
				}
		}

		public static void PlaneWaveTM()
		{
			for (int i = CommonParams.InitialX1; i < CommonParams.InitialX2; i++)
				for (int j = CommonParams.InitialY1; j < CommonParams.InitialY2; j++)
				{
					if ((i + j + 2)%2 == 0)
					{
						CommonParams.Ey[i, j] = PhisicalConstants.Ez0
						                   *
						                   ExtMath.Sin(ExtMath.Pi*CommonParams.HalfPX*(i - CommonParams.InitialX1)/
						                               (CommonParams.InitialX2 - CommonParams.InitialX1))
						                   *
						                   ExtMath.Cos(ExtMath.Pi*CommonParams.HalfPY*(j - CommonParams.InitialY1)/
						                               (CommonParams.InitialY2 - CommonParams.InitialY1));
						CommonParams.Dy[i, j] = CommonParams.Ez[i, j]*PhisicalConstants.Eps0*RegionList.Eps;
					}
					else
					{
						CommonParams.Hz[i, j] = PhisicalConstants.Hz0
						                   *
						                   ExtMath.Sin(ExtMath.Pi*CommonParams.HalfPX*(i - CommonParams.InitialX1)/
						                               (CommonParams.InitialX2 - CommonParams.InitialX1))
						                   *
						                   ExtMath.Cos(ExtMath.Pi*CommonParams.HalfPY*(j - CommonParams.InitialY1)/
						                               (CommonParams.InitialY2 - CommonParams.InitialY1));
						CommonParams.Bz[i, j] = CommonParams.Hy[i, j]*PhisicalConstants.Mu0;
					}
				}
		}

		public static void GaussTE()
		{
			for (int i = CommonParams.InitialX1; i < CommonParams.InitialX2; i++)
				for (int j = CommonParams.InitialY1; j < CommonParams.InitialY2; j++)
				{
					if ((i + j + 2)%2 == 0)
					{
						CommonParams.Ez[i, j] = PhisicalConstants.Ez0
						                   *
						                   ExtMath.Sin(ExtMath.Pi*CommonParams.HalfPX*(i - CommonParams.InitialX1)/
						                               (CommonParams.InitialX2 - CommonParams.InitialX1))
						                   *
						                   ExtMath.Sin(ExtMath.Pi*CommonParams.HalfPY*(j - CommonParams.InitialY1)/
						                               (CommonParams.InitialY2 - CommonParams.InitialY1))
						                   *ExtMath.Exp(-ExtMath.Pow(CommonParams.ExpX*(i - (CommonParams.InitialX1 + CommonParams.InitialX2)/2), 2)
						                                - ExtMath.Pow(CommonParams.ExpY*(j - (CommonParams.InitialY1 + CommonParams.InitialY2)/2), 2));
						CommonParams.Dz[i, j] = CommonParams.Ez[i, j]*PhisicalConstants.Eps0*RegionList.Eps;
					}
					else
					{
						CommonParams.Hy[i, j] = PhisicalConstants.Hz0
						                   *
						                   ExtMath.Sin(ExtMath.Pi*CommonParams.HalfPX*(i - CommonParams.InitialX1)/
						                               (CommonParams.InitialX2 - CommonParams.InitialX1))
						                   *
						                   ExtMath.Sin(ExtMath.Pi*CommonParams.HalfPY*(j - CommonParams.InitialY1)/
						                               (CommonParams.InitialY2 - CommonParams.InitialY1))
						                   *ExtMath.Exp(-ExtMath.Pow(CommonParams.ExpX*(i - (CommonParams.InitialX1 + CommonParams.InitialX2)/2), 2)
						                                - ExtMath.Pow(CommonParams.ExpY*(j - (CommonParams.InitialY1 + CommonParams.InitialY2)/2), 2));
						CommonParams.By[i, j] = CommonParams.Hy[i, j]*PhisicalConstants.Mu0;
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
				RegionList.FieldList[i].FillEx(CommonParams.Ex);
				RegionList.FieldList[i].FillEy(CommonParams.Ey);
				RegionList.FieldList[i].FillEz(CommonParams.Ez);
				RegionList.FieldList[i].FillDx(CommonParams.Dx);
				RegionList.FieldList[i].FillDy(CommonParams.Dy);
				RegionList.FieldList[i].FillDz(CommonParams.Dz);
				RegionList.FieldList[i].FillBx(CommonParams.Bx);
				RegionList.FieldList[i].FillBy(CommonParams.By);
				RegionList.FieldList[i].FillBz(CommonParams.Bz);
				RegionList.FieldList[i].FillHx(CommonParams.Hx);
				RegionList.FieldList[i].FillHy(CommonParams.Hy);
				RegionList.FieldList[i].FillHz(CommonParams.Hz);
			}
		}
	}
}