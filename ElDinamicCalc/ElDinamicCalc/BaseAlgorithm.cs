namespace ElDinamicCalc
{
	/// <summary>
	/// Инкапсулирует базовый алгоритм 
	/// </summary>
	public class BaseAlgorithm
	{
		private const decimal SigmaX = 2 * ExtMath.Pi * PhisicalConstants.Eps0 / 1000;
		private const decimal SigmaY = 2 * ExtMath.Pi * PhisicalConstants.Eps0 / 1000;
		private readonly int _boundWidth = CommonParams.BoundWidth0;
		private readonly decimal _coefG = CommonParams.G;
		private readonly int _sizeX = CommonParams.SizeX0;
		private readonly int _sizeY = CommonParams.SizeY0;
		
		public BaseAlgorithm()
		{
			CreateFields();
			if (RegionList.BoundsType == BoundsType.Absorb)
				SetSigmaCoeffs();
			if (CommonParams.IntEnable)
				SetIntMode();
		}

		/// <summary>
		/// Номер шага
		/// </summary>
		public int StepNumber { get; set; }
		/// <summary>
		/// Выполняет вычисления согласно алгоритма (шаг алгоритма)
		/// </summary>
		public void DoStep()
		{
			for (var i = 0; i < CommonParams.SizeX; i++)
				for (var j = 0; j < CommonParams.SizeY; j++)
				{
					if (((i + j + 2) % 2 == 0) && ((StepNumber + 2) % 2 == 0))
					{
						switch (CommonParams.ModeType)
						{
							case ModeType.TE:
								ElectrTE(i, j);
								break;
							case ModeType.TM:
								ElectrTM(i, j);
								break;
						}
					}
					if (((i + j + 2) % 2 == 1) && ((StepNumber + 2) % 2 == 1))
					{
						switch (CommonParams.ModeType)
						{
							case ModeType.TE:
								MagnTE(i, j);
								break;
							case ModeType.TM:
								MagnTM(i, j);
								break;
						}
					}
				}
			Next();
		}

		private void CreateFields()
		{
			CommonParams.Ez = new ExtArr(_sizeX + 2, _sizeY + 2, 0, 0, 0, 0, -1, -1);
			CommonParams.EzN = new ExtArr(_sizeX + 2, _sizeY + 2, 0, 0, 0, 0, -1, -1);
			CommonParams.Ex = new ExtArr(_sizeX + 2, _sizeY + 2, 0, 0, 0, 0, -1, -1);
			CommonParams.ExN = new ExtArr(_sizeX + 2, _sizeY + 2, 0, 0, 0, 0, -1, -1);
			CommonParams.Ey = new ExtArr(_sizeX + 2, _sizeY + 2, 0, 0, 0, 0, -1, -1);
			CommonParams.EyN = new ExtArr(_sizeX + 2, _sizeY + 2, 0, 0, 0, 0, -1, -1);
			CommonParams.Dz = new ExtArr(_sizeX + 2, _sizeY + 2, 0, 0, 0, 0, -1, -1);
			CommonParams.DzN = new ExtArr(_sizeX + 2, _sizeY + 2, 0, 0, 0, 0, -1, -1);
			CommonParams.Dx = new ExtArr(_sizeX + 2, _sizeY + 2, 0, 0, 0, 0, -1, -1);
			CommonParams.DxN = new ExtArr(_sizeX + 2, _sizeY + 2, 0, 0, 0, 0, -1, -1);
			CommonParams.Dy = new ExtArr(_sizeX + 2, _sizeY + 2, 0, 0, 0, 0, -1, -1);
			CommonParams.DyN = new ExtArr(_sizeX + 2, _sizeY + 2, 0, 0, 0, 0, -1, -1);
			CommonParams.Bz = new ExtArr(_sizeX + 2, _sizeY + 2, 0, 0, 0, 0, -1, -1);
			CommonParams.BzN = new ExtArr(_sizeX + 2, _sizeY + 2, 0, 0, 0, 0, -1, -1);
			CommonParams.Bx = new ExtArr(_sizeX + 2, _sizeY + 2, 0, 0, 0, 0, -1, -1);
			CommonParams.BxN = new ExtArr(_sizeX + 2, _sizeY + 2, 0, 0, 0, 0, -1, -1);
			CommonParams.By = new ExtArr(_sizeX + 2, _sizeY + 2, 0, 0, 0, 0, -1, -1);
			CommonParams.ByN = new ExtArr(_sizeX + 2, _sizeY + 2, 0, 0, 0, 0, -1, -1);
			CommonParams.Hz = new ExtArr(_sizeX + 2, _sizeY + 2, 0, 0, 0, 0, -1, -1);
			CommonParams.HzN = new ExtArr(_sizeX + 2, _sizeY + 2, 0, 0, 0, 0, -1, -1);
			CommonParams.Hx = new ExtArr(_sizeX + 2, _sizeY + 2, 0, 0, 0, 0, -1, -1);
			CommonParams.HxN = new ExtArr(_sizeX + 2, _sizeY + 2, 0, 0, 0, 0, -1, -1);
			CommonParams.Hy = new ExtArr(_sizeX + 2, _sizeY + 2, 0, 0, 0, 0, -1, -1);
			CommonParams.HyN = new ExtArr(_sizeX + 2, _sizeY + 2, 0, 0, 0, 0, -1, -1);

			CommonParams.Exy = new ExtArr(_sizeX + 2*_boundWidth, _sizeY + 2*_boundWidth, _boundWidth, _boundWidth, _sizeX, _sizeY,
				-_boundWidth,
				-_boundWidth);
			CommonParams.Exz = new ExtArr(_sizeX + 2*_boundWidth, _sizeY + 2*_boundWidth, _boundWidth, _boundWidth, _sizeX, _sizeY,
				-_boundWidth,
				-_boundWidth);
			CommonParams.Eyx = new ExtArr(_sizeX + 2*_boundWidth, _sizeY + 2*_boundWidth, _boundWidth, _boundWidth, _sizeX, _sizeY,
				-_boundWidth,
				-_boundWidth);
			CommonParams.Eyz = new ExtArr(_sizeX + 2*_boundWidth, _sizeY + 2*_boundWidth, _boundWidth, _boundWidth, _sizeX, _sizeY,
				-_boundWidth,
				-_boundWidth);
			CommonParams.Ezx = new ExtArr(_sizeX + 2*_boundWidth, _sizeY + 2*_boundWidth, _boundWidth, _boundWidth, _sizeX, _sizeY,
				-_boundWidth,
				-_boundWidth);
			CommonParams.Ezy = new ExtArr(_sizeX + 2*_boundWidth, _sizeY + 2*_boundWidth, _boundWidth, _boundWidth, _sizeX, _sizeY,
				-_boundWidth,
				-_boundWidth);
			CommonParams.Hxy = new ExtArr(_sizeX + 2*_boundWidth, _sizeY + 2*_boundWidth, _boundWidth, _boundWidth, _sizeX, _sizeY,
				-_boundWidth,
				-_boundWidth);
			CommonParams.Hxz = new ExtArr(_sizeX + 2*_boundWidth, _sizeY + 2*_boundWidth, _boundWidth, _boundWidth, _sizeX, _sizeY,
				-_boundWidth,
				-_boundWidth);
			CommonParams.Hyx = new ExtArr(_sizeX + 2*_boundWidth, _sizeY + 2*_boundWidth, _boundWidth, _boundWidth, _sizeX, _sizeY,
				-_boundWidth,
				-_boundWidth);
			CommonParams.Hyz = new ExtArr(_sizeX + 2*_boundWidth, _sizeY + 2*_boundWidth, _boundWidth, _boundWidth, _sizeX, _sizeY,
				-_boundWidth,
				-_boundWidth);
			CommonParams.Hzx = new ExtArr(_sizeX + 2*_boundWidth, _sizeY + 2*_boundWidth, _boundWidth, _boundWidth, _sizeX, _sizeY,
				-_boundWidth,
				-_boundWidth);
			CommonParams.Hzy = new ExtArr(_sizeX + 2*_boundWidth, _sizeY + 2*_boundWidth, _boundWidth, _boundWidth, _sizeX, _sizeY,
				-_boundWidth,
				-_boundWidth);
			CommonParams.ExyN = new ExtArr(_sizeX + 2*_boundWidth, _sizeY + 2*_boundWidth, _boundWidth, _boundWidth, _sizeX, _sizeY,
				-_boundWidth,
				-_boundWidth);
			CommonParams.ExzN = new ExtArr(_sizeX + 2*_boundWidth, _sizeY + 2*_boundWidth, _boundWidth, _boundWidth, _sizeX, _sizeY,
				-_boundWidth,
				-_boundWidth);
			CommonParams.EyxN = new ExtArr(_sizeX + 2*_boundWidth, _sizeY + 2*_boundWidth, _boundWidth, _boundWidth, _sizeX, _sizeY,
				-_boundWidth,
				-_boundWidth);
			CommonParams.EyzN = new ExtArr(_sizeX + 2*_boundWidth, _sizeY + 2*_boundWidth, _boundWidth, _boundWidth, _sizeX, _sizeY,
				-_boundWidth,
				-_boundWidth);
			CommonParams.EzxN = new ExtArr(_sizeX + 2*_boundWidth, _sizeY + 2*_boundWidth, _boundWidth, _boundWidth, _sizeX, _sizeY,
				-_boundWidth,
				-_boundWidth);
			CommonParams.EzyN = new ExtArr(_sizeX + 2*_boundWidth, _sizeY + 2*_boundWidth, _boundWidth, _boundWidth, _sizeX, _sizeY,
				-_boundWidth,
				-_boundWidth);
			CommonParams.HxyN = new ExtArr(_sizeX + 2*_boundWidth, _sizeY + 2*_boundWidth, _boundWidth, _boundWidth, _sizeX, _sizeY,
				-_boundWidth,
				-_boundWidth);
			CommonParams.HxzN = new ExtArr(_sizeX + 2*_boundWidth, _sizeY + 2*_boundWidth, _boundWidth, _boundWidth, _sizeX, _sizeY,
				-_boundWidth,
				-_boundWidth);
			CommonParams.HyxN = new ExtArr(_sizeX + 2*_boundWidth, _sizeY + 2*_boundWidth, _boundWidth, _boundWidth, _sizeX, _sizeY,
				-_boundWidth,
				-_boundWidth);
			CommonParams.HyzN = new ExtArr(_sizeX + 2*_boundWidth, _sizeY + 2*_boundWidth, _boundWidth, _boundWidth, _sizeX, _sizeY,
				-_boundWidth,
				-_boundWidth);
			CommonParams.HzxN = new ExtArr(_sizeX + 2*_boundWidth, _sizeY + 2*_boundWidth, _boundWidth, _boundWidth, _sizeX, _sizeY,
				-_boundWidth,
				-_boundWidth);
			CommonParams.HzyN = new ExtArr(_sizeX + 2*_boundWidth, _sizeY + 2*_boundWidth, _boundWidth, _boundWidth, _sizeX, _sizeY,
				-_boundWidth,
				-_boundWidth);
		}

		//меняет местами указатели на две компоненты поля
		private void SwapFields(ref ExtArr field1, ref ExtArr field2)
		{
			var temp = field2;
			field2 = field1;
			field1 = temp;
		}

		//следующие 6 функций возращают значения компонент в точке:
		//само значение, если точка внутри системы
		//иначе - сумма значений расщепленных компонент
		private decimal GetEx(int i, int j)
		{
			if ((i >= 0) && (i < _sizeX) && (j >= 0) && (j < _sizeY))
				return CommonParams.Ex[i, j];
			return CommonParams.Exy[i, j] + CommonParams.Exz[i, j];
		}

		private decimal GetEy(int i, int j)
		{
			if ((i >= 0) && (i < _sizeX) && (j >= 0) && (j < _sizeY))
				return CommonParams.Ey[i, j];
			return CommonParams.Eyx[i, j] + CommonParams.Eyz[i, j];
		}

		private decimal GetEz(int i, int j)
		{
			if ((i >= 0) && (i < _sizeX) && (j >= 0) && (j < _sizeY))
				return CommonParams.Ez[i, j];
			return CommonParams.Ezx[i, j] + CommonParams.Ezy[i, j];
		}
		
		private decimal GetHx(int i, int j)
		{
			if ((i >= 0) && (i < _sizeX) && (j >= 0) && (j < _sizeY))
				return CommonParams.Hx[i, j];
			return CommonParams.Hxy[i, j] + CommonParams.Hxz[i, j];
		}

		private decimal GetHy(int i, int j)
		{
			if ((i >= 0) && (i < _sizeX) && (j >= 0) && (j < _sizeY))
				return CommonParams.Hy[i, j];
			return CommonParams.Hyx[i, j] + CommonParams.Hyz[i, j];
		}

		private decimal GetHz(int i, int j)
		{
			if ((i >= 0) && (i < _sizeX) && (j >= 0) && (j < _sizeY))
				return CommonParams.Hz[i, j];
			return CommonParams.Hzx[i, j] + CommonParams.Hzy[i, j];
		}

		//следующие 6 функций возращают значения параметров Sigma в точке
		//учитывается расстояние до границы системы
		private decimal GetSigmaX(int i, int j)
		{
			if (i < 0)
				return SigmaX*ExtMath.Degree(_coefG, -i + 1);
			if (i >= _sizeX)
				return SigmaX*ExtMath.Degree(_coefG, i - _sizeX);
			return SigmaX;
		}

		private decimal GetSigmaY(int i, int j)
		{
			if (j < 0)
				return SigmaY*ExtMath.Degree(_coefG, -j + 1);
			if (j >= _sizeY)
				return SigmaY*ExtMath.Degree(_coefG, j - _sizeY);
			return SigmaY;
		}

		private decimal GetSigmaZ(int i, int j)
		{
			return 0;
		}

		private decimal GetSigmaXS(int i, int j)
		{
			return GetSigmaX(i, j)*PhisicalConstants.MuDivEps;
		}

		private decimal GetSigmaYS(int i, int j)
		{
			return GetSigmaY(i, j)*PhisicalConstants.MuDivEps;
		}

		private decimal GetSigmaZS(int i, int j)
		{
			return GetSigmaZ(i, j)*PhisicalConstants.MuDivEps;
		}


		private void ElectrTE(int i, int j)
		{
			var eps = RegionList.EpsField[i, j]*PhisicalConstants.Eps0 + RegionList.Eps2Field[i, j]
			              *PhisicalConstants.Eps0*ExtMath.Sqrt(CommonParams.Ez[i, j]/PhisicalConstants.Ez0);
			CommonParams.DzN[i, j] = CommonParams.Dz[i, j] + CommonParams.DtDivDx*(CommonParams.Hy[i + 1, j] - CommonParams.Hy[i - 1, j])
			                    - CommonParams.DtDivDy*(CommonParams.Hx[i, j + 1] - CommonParams.Hx[i, j - 1]);
			if (eps != 0)
				CommonParams.EzN[i, j] = CommonParams.DzN[i, j]/eps;
			else
				CommonParams.EzN[i, j] = 0;
		}

		private void ElectrTM(int i, int j)
		{
		}

		private void MagnTE(int i, int j)
		{
			CommonParams.BxN[i, j] = CommonParams.Bx[i, j] - CommonParams.DtDivDy*(CommonParams.Ez[i, j + 1] - CommonParams.Ez[i, j - 1]);
			CommonParams.ByN[i, j] = CommonParams.By[i, j] + CommonParams.DtDivDx*(CommonParams.Ez[i + 1, j] - CommonParams.Ez[i - 1, j]);
			CommonParams.HxN[i, j] = CommonParams.BxN[i, j]/PhisicalConstants.Mu0;
			CommonParams.HyN[i, j] = CommonParams.ByN[i, j]/PhisicalConstants.Mu0;
		}

		private void MagnTM(int i, int j)
		{
		}

		private void MetallABC()
		{
			for (int i = 0; i < _sizeX; i++)
			{
				//верхняя стенка
				CommonParams.Ez[i, 0] = 0;
				CommonParams.Dz[i, 0] = 0;
				CommonParams.Ez[i, -1] = -CommonParams.Ez[i, 1];
				CommonParams.Dz[i, -1] = -CommonParams.Dz[i, 1];

				//нижняя стенка
				CommonParams.Ez[i, _sizeY - 1] = 0;
				CommonParams.Dz[i, _sizeY - 1] = 0;
				CommonParams.Ez[i, _sizeY] = -CommonParams.Ez[i, _sizeY - 2];
				CommonParams.Dz[i, _sizeY] = -CommonParams.Dz[i, _sizeY - 2];
			}

			for (int j = 0; j < _sizeY; j++)
			{
				//левая стенка
				CommonParams.Ez[0, j] = 0;
				CommonParams.Dz[0, j] = 0;
				CommonParams.Ez[-1, j] = -CommonParams.Ez[1, j];
				CommonParams.Dz[-1, j] = -CommonParams.Dz[1, j];

				//правая стенка
				CommonParams.Ez[_sizeX - 1, j] = 0;
				CommonParams.Dz[_sizeX - 1, j] = 0;
				CommonParams.Ez[_sizeX, j] = -CommonParams.Ez[_sizeX - 2, j];
				CommonParams.Dz[_sizeX, j] = -CommonParams.Dz[_sizeX - 2, j];
			}
		}

		private void AbsElectr()
		{
			for (int i = -CommonParams.BoundWidth; i < _sizeX + CommonParams.BoundWidth; i++)
				for (int j = -CommonParams.BoundWidth; j < _sizeY + CommonParams.BoundWidth; j++)
				{
					if ((i < 0) || (i >= _sizeX) || (j < 0) || (j >= _sizeY))
					{
						switch (CommonParams.ModeType)
						{
							case ModeType.TE:
								CommonParams.EzxN[i, j] = CommonParams.Ezx[i, j]*CommonParams.SigmaXCoeffs[i, j]
								                     + CommonParams.OneDivSigmaX[i, j]*(GetHy(i + 1, j) - GetHy(i - 1, j))
								                     *(1 - CommonParams.SigmaXCoeffs[i, j]);
								CommonParams.EzyN[i, j] = CommonParams.Ezy[i, j]*CommonParams.SigmaXCoeffs[i, j] - CommonParams.OneDivSigmaY[i, j]
								                     *(GetHx(i, j + 1) - GetHx(i, j - 1))*(1 - CommonParams.SigmaYCoeffs[i, j]);
								break;

							case ModeType.TM:
								CommonParams.ExyN[i, j] = CommonParams.Exy[i, j]*ExtMath.Log(-GetSigmaY(i, j)
								                                                   *CommonParams.DelT/PhisicalConstants.Eps0)
								                     + 1/CommonParams.DelY/GetSigmaY(i, j)*(GetHz(i, j + 1)
								                                                       - GetHz(i, j - 1))*(1 - ExtMath.Log(-GetSigmaY(i, j)
								                                                                                           *CommonParams.DelT/
								                                                                                           PhisicalConstants.Eps0));
								CommonParams.ExzN[i, j] = CommonParams.Exz[i, j]*ExtMath.Log(-GetSigmaZ(0, 0)
								                                                   *CommonParams.DelT/PhisicalConstants.Eps0);
								CommonParams.EyxN[i, j] = CommonParams.Eyx[i, j]*ExtMath.Log(-GetSigmaX(i, j)
								                                                   *CommonParams.DelT/PhisicalConstants.Eps0) - 1/CommonParams.DelX
								                     /GetSigmaX(i, j)*(GetHz(i + 1, j) - GetHz(i - 1, j))
								                     *(1 - ExtMath.Log(-GetSigmaX(i, j)*CommonParams.DelT/PhisicalConstants.Eps0));
								CommonParams.EyzN[i, j] = CommonParams.Eyz[i, j]*ExtMath.Log(-GetSigmaZ(0, 0)*CommonParams.DelT/PhisicalConstants.Eps0);
								break;
						}
					}
				}
		}

		//расчет магнитных расщепленных компонент
		private void AbsMagn()
		{
			for (int i = -CommonParams.BoundWidth; i < _sizeX + CommonParams.BoundWidth; i++)
				for (int j = -CommonParams.BoundWidth; j < _sizeY + CommonParams.BoundWidth; j++)
				{
					if ((i < 0) || (i >= _sizeX) || (j < 0) || (j >= _sizeY))
					{
						switch (CommonParams.ModeType)
						{
							case ModeType.TE:
								CommonParams.HxyN[i, j] = CommonParams.Hxy[i, j]*CommonParams.SigmaYSCoeffs[i, j]
								                     - CommonParams.OneDivSigmaYS[i, j]
								                     *(GetEz(i, j + 1) - GetEz(i, j - 1))
								                     *(1 - CommonParams.SigmaYSCoeffs[i, j]);
								CommonParams.HxzN[i, j] = CommonParams.Hxz[i, j]*CommonParams.SigmaZSCoeffs[i, j];
								CommonParams.HyxN[i, j] = CommonParams.Hyx[i, j]*CommonParams.SigmaXSCoeffs[i, j]
								                     + CommonParams.OneDivSigmaXS[i, j]
								                     *(GetEz(i + 1, j) - GetEz(i - 1, j))
								                     *(1 - CommonParams.SigmaXSCoeffs[i, j]);
								CommonParams.HyzN[i, j] = CommonParams.Hyz[i, j]*CommonParams.SigmaZSCoeffs[i, j];
								break;

							case ModeType.TM:
								CommonParams.HzxN[i, j] = CommonParams.Hzx[i, j]*ExtMath.Log(-GetSigmaXS(i, j)
								                                                   *CommonParams.DelT/PhisicalConstants.Mu0) - 1/CommonParams.DelX/GetSigmaXS(i, j)
								                     *(GetEy(i + 1, j) - GetEy(i - 1, j))
								                     *(1 - ExtMath.Log(-GetSigmaXS(i, j)*CommonParams.DelT/PhisicalConstants.Mu0));
								CommonParams.HzyN[i, j] = CommonParams.Hzy[i, j]*ExtMath.Log(-GetSigmaYS(i, j)*CommonParams.DelT
								                                                   /PhisicalConstants.Mu0) + 1/CommonParams.DelY/GetSigmaYS(i, j)
								                     *(GetEx(i, j + 1) - GetEx(i, j - 1))
								                     *(1 - ExtMath.Log(-GetSigmaYS(i, j)*CommonParams.DelT/PhisicalConstants.Mu0));
								break;
						}
					}
				}
		}

		//граничные условия - поглощающие слои
		//перешагивание во времени
		private void AbsLayersABC()
		{
			if ((StepNumber + 2) % 2 == 0)
			{
				AbsElectr();

				for (int i = -1; i <= _sizeX; i++)
				{
					CommonParams.Ex[i, -1] = GetEx(i, -1);
					CommonParams.Ey[i, -1] = GetEy(i, -1);
					CommonParams.Ez[i, -1] = GetEz(i, -1);
					CommonParams.Ex[i, CommonParams.SizeY] = GetEx(i, CommonParams.SizeY);
					CommonParams.Ey[i, CommonParams.SizeY] = GetEy(i, CommonParams.SizeY);
					CommonParams.Ez[i, CommonParams.SizeY] = GetEz(i, CommonParams.SizeY);
				}
				for (int j = -1; j <= _sizeY; j++)
				{
					CommonParams.Ex[-1, j] = GetEx(-1, j);
					CommonParams.Ey[-1, j] = GetEy(-1, j);
					CommonParams.Ez[-1, j] = GetEz(-1, j);
					CommonParams.Ex[_sizeX, j] = GetEx(_sizeX, j);
					CommonParams.Ey[_sizeX, j] = GetEy(_sizeX, j);
					CommonParams.Ez[_sizeX, j] = GetEz(_sizeX, j);
				}
			}
			else
			{
				AbsMagn();
				for (int i = -1; i <= _sizeX; i++)
				{
					CommonParams.Hx[i, -1] = GetHx(i, -1);
					CommonParams.Hy[i, -1] = GetHy(i, -1);
					CommonParams.Hz[i, -1] = GetHz(i, -1);
					CommonParams.Hx[i, _sizeY] = GetHx(i, _sizeY);
					CommonParams.Hy[i, _sizeY] = GetHy(i, _sizeY);
					CommonParams.Hz[i, _sizeY] = GetHz(i, _sizeY);
				}

				for (int j = -1; j <= _sizeY; j++)
				{
					CommonParams.Hx[-1, j] = GetHx(-1, j);
					CommonParams.Hy[-1, j] = GetHy(-1, j);
					CommonParams.Hz[-1, j] = GetHz(-1, j);
					CommonParams.Hx[_sizeX, j] = GetHx(_sizeX, j);
					CommonParams.Hy[_sizeX, j] = GetHy(_sizeX, j);
					CommonParams.Hz[_sizeX, j] = GetHz(_sizeX, j);
				}
			}
		}

		//переход к следующему шагу
		private void Next()
		{
			//учет граничных условий
			switch (RegionList.BoundsType)
			{
				case BoundsType.Metall:
					MetallABC();
					break;
				case BoundsType.Absorb:
					AbsLayersABC();
					break;
			}

			//замена массивов со старыми значениями на массивы с новыми
			//значениями с учетом перешагивания во времени
			if ((StepNumber + 2) % 2 == 0)
			{
				SwapFields(ref CommonParams.Ex, ref CommonParams.ExN);
				SwapFields(ref CommonParams.Ey, ref CommonParams.EyN);
				SwapFields(ref CommonParams.Ez, ref CommonParams.EzN);
				SwapFields(ref CommonParams.Dx, ref CommonParams.DxN);
				SwapFields(ref CommonParams.Dy, ref CommonParams.DyN);
				SwapFields(ref CommonParams.Dz, ref CommonParams.DzN);
				SwapFields(ref CommonParams.Exy, ref CommonParams.ExyN);
				SwapFields(ref CommonParams.Exz, ref CommonParams.ExzN);
				SwapFields(ref CommonParams.Eyx, ref CommonParams.EyxN);
				SwapFields(ref CommonParams.Eyz, ref CommonParams.EyzN);
				SwapFields(ref CommonParams.Ezx, ref CommonParams.EzxN);
				SwapFields(ref CommonParams.Ezy, ref CommonParams.EzyN);
			}
			else
			{
				SwapFields(ref CommonParams.Hx, ref CommonParams.HxN);
				SwapFields(ref CommonParams.Hy, ref CommonParams.HyN);
				SwapFields(ref CommonParams.Hz, ref CommonParams.HzN);
				SwapFields(ref CommonParams.Bx, ref CommonParams.BxN);
				SwapFields(ref CommonParams.By, ref CommonParams.ByN);
				SwapFields(ref CommonParams.Bz, ref CommonParams.BzN);
				SwapFields(ref CommonParams.Hxy, ref CommonParams.HxyN);
				SwapFields(ref CommonParams.Hxz, ref CommonParams.HxzN);
				SwapFields(ref CommonParams.Hyx, ref CommonParams.HyxN);
				SwapFields(ref CommonParams.Hyz, ref CommonParams.HyzN);
				SwapFields(ref CommonParams.Hzx, ref CommonParams.HzxN);
				SwapFields(ref CommonParams.Hzy, ref CommonParams.HzyN);
			}

			StepNumber++;
		}

		private void SetSigmaCoeffs()
		{
			CommonParams.SigmaXCoeffs = new ExtArr(_sizeX + 2*_boundWidth,
				_sizeY + 2*_boundWidth, _boundWidth, _boundWidth, _sizeX, _sizeY,
				-_boundWidth, -_boundWidth);
			CommonParams.SigmaYCoeffs = new ExtArr(_sizeX + 2*_boundWidth,
				_sizeY + 2*_boundWidth, _boundWidth, _boundWidth, _sizeX, _sizeY,
				-_boundWidth, -_boundWidth);
			CommonParams.SigmaZCoeffs = new ExtArr(_sizeX + 2*_boundWidth,
				_sizeY + 2*_boundWidth, _boundWidth, _boundWidth, _sizeX, _sizeY,
				-_boundWidth, -_boundWidth);

			CommonParams.SigmaXSCoeffs = new ExtArr(_sizeX + 2*_boundWidth,
				_sizeY + 2*_boundWidth, _boundWidth, _boundWidth, _sizeX, _sizeY,
				-_boundWidth, -_boundWidth);
			CommonParams.SigmaYSCoeffs = new ExtArr(_sizeX + 2*_boundWidth,
				_sizeY + 2*_boundWidth, _boundWidth, _boundWidth, _sizeX, _sizeY,
				-_boundWidth, -_boundWidth);
			CommonParams.SigmaZSCoeffs = new ExtArr(_sizeX + 2*_boundWidth,
				_sizeY + 2*_boundWidth, _boundWidth, _boundWidth, _sizeX, _sizeY,
				-_boundWidth, -_boundWidth);

			CommonParams.OneDivSigmaX = new ExtArr(_sizeX + 2*_boundWidth,
				_sizeY + 2*_boundWidth, _boundWidth, _boundWidth, _sizeX, _sizeY,
				-_boundWidth, -_boundWidth);
			CommonParams.OneDivSigmaY = new ExtArr(_sizeX + 2*_boundWidth,
				_sizeY + 2*_boundWidth, _boundWidth, _boundWidth, _sizeX, _sizeY,
				-_boundWidth, -_boundWidth);

			CommonParams.OneDivSigmaXS = new ExtArr(_sizeX + 2*_boundWidth,
				_sizeY + 2*_boundWidth, _boundWidth, _boundWidth, _sizeX, _sizeY,
				-_boundWidth, -_boundWidth);
			CommonParams.OneDivSigmaYS = new ExtArr(_sizeX + 2*_boundWidth,
				_sizeY + 2*_boundWidth, _boundWidth, _boundWidth, _sizeX, _sizeY,
				-_boundWidth, -_boundWidth);

			for (int i = -_boundWidth; i < _sizeX + _boundWidth; i++)
				for (int j = -_boundWidth; j < _sizeY + _boundWidth; j++)
				{
					if ((i < 0) || (i >= _sizeX) || (j < 0) || (j >= _sizeY))
					{
						CommonParams.SigmaXCoeffs[i, j] = ExtMath.Log(-GetSigmaX(i, j)/PhisicalConstants.Eps0
						                                         *CommonParams.DelT);
						CommonParams.SigmaYCoeffs[i, j] = ExtMath.Log(-GetSigmaY(i, j)/PhisicalConstants.Eps0
						                                         *CommonParams.DelT);
						CommonParams.SigmaXSCoeffs[i, j] = ExtMath.Log(-GetSigmaXS(i, j)/PhisicalConstants.Mu0
						                                          *CommonParams.DelT);
						CommonParams.SigmaYSCoeffs[i, j] = ExtMath.Log(-GetSigmaYS(i, j)/PhisicalConstants.Mu0
						                                          *CommonParams.DelT);
						CommonParams.OneDivSigmaX[i, j] = 1/CommonParams.DelX/GetSigmaX(i, j);
						CommonParams.OneDivSigmaY[i, j] = 1/CommonParams.DelY/GetSigmaY(i, j);
						CommonParams.OneDivSigmaXS[i, j] = 1/CommonParams.DelX/GetSigmaXS(i, j);
						CommonParams.OneDivSigmaYS[i, j] = 1/CommonParams.DelY/GetSigmaYS(i, j);
					}
				}
		}

		private void FreeSigmaCoeffs()
		{
			CommonParams.SigmaXCoeffs = null;
			CommonParams.SigmaYCoeffs = null;
			CommonParams.SigmaZCoeffs = null;
			CommonParams.SigmaXSCoeffs = null;
			CommonParams.SigmaYSCoeffs = null;
			CommonParams.SigmaZSCoeffs = null;
			CommonParams.OneDivSigmaX = null;
			CommonParams.OneDivSigmaY = null;
			CommonParams.OneDivSigmaXS = null;
			CommonParams.OneDivSigmaYS = null;
		}

		private void SetIntMode()
		{
			CommonParams.IntFModeEz = new ExtArr(1, _sizeY, 0, 0, 0, 0, 0, 0);
			CommonParams.IntFModeHy = new ExtArr(1, _sizeY, 0, 0, 0, 0, 0, 0);
			var number = -1;
			var count = 0;
			while (number < CommonParams.SelfModeNumber)
			{
				if ((RegionList.FieldList[count].FieldType != InitialFieldType.RectSelf) &&
				    (RegionList.FieldList[count].FieldType != InitialFieldType.RectSelf2)) continue;
				number++;
				count++;
			}

			RegionList.FieldList[number].FillEzMax(CommonParams.IntFModeEz);
			RegionList.FieldList[number].FillHyMax(CommonParams.IntFModeHy);
			CommonParams.BettaX = RegionList.FieldList[number].BettaX;
			CommonParams.BettaY = RegionList.FieldList[number].BettaY;
		}
	}
}