using System;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Linq;
using System.Threading;

namespace ElDinamicCalc
{
	/// <summary>
	/// Инкапсулирует в себе поток выполняющий основные вычисления
	/// </summary>
	public class MainThread
	{
		private const int SourcePixelSize = 4;
		private static readonly int SourceStride = CommonParams.SizeX * SourcePixelSize;
		private static readonly int Bytes = Math.Abs(SourceStride) * CommonParams.SizeY;
		private readonly decimal _max = CommonParams.BlackValue * GetMaxValue(FieldType.EType);
		private readonly decimal _min = CommonParams.WhiteValue * GetMaxValue(FieldType.EType);
		private readonly byte[] _contour = new byte[Bytes];
		private readonly BaseAlgorithm _algorithm = new BaseAlgorithm();
		private Color[] _colors;
		private WorkMode _workMode;
		private bool _isWorking;
		
		/// <summary>
		/// Конструктор класса
		/// </summary>
		/// <param name="filePath">Путь к файлу с настройками системы</param>
		public MainThread(string filePath)
		{
			RegionList.LoadFromFile(filePath);

			CommonParams.SizeX = RegionList.SizeOfX;
			CommonParams.SizeY = RegionList.SizeOfY;
			CommonParams.DelX = RegionList.DelX;
			CommonParams.DelY = RegionList.DelY;
			CommonParams.DelT = RegionList.DelT;
			CommonParams.DtDivDx = CommonParams.DelT / CommonParams.DelX;
			CommonParams.DtDivDy = CommonParams.DelT / CommonParams.DelY;

			CommonParams.BoundWidth = RegionList.BoundsWidth;
			CommonParams.SigmaX = RegionList.Sigma;
			CommonParams.SigmaY = RegionList.Sigma;

			CommonParams.CoefG = RegionList.CoefG;

			if (CommonParams.InitialX2 >= CommonParams.SizeX)
				CommonParams.InitialX2 = CommonParams.SizeX - 1;
			if (CommonParams.InitialY2 >= CommonParams.SizeY)
				CommonParams.InitialY2 = CommonParams.SizeY - 1;

			InitColorArray();
			_contour = RegionList.Contour;

			MakeCalc();
		}
		/// <summary>
		/// Запускает поток вычислений
		/// </summary>
		/// <param name="workMode">Режим работы (многопоточный/однопоточный)</param>
		public void Start(WorkMode workMode)
		{
			_workMode = workMode;
			ThreadPool.QueueUserWorkItem(DoWork);
		}
		/// <summary>
		/// Останавливает поток вычислений
		/// </summary>
		public void Stop()
		{
			_isWorking = false;
		}

		private void DoWork(object state)
		{
			_isWorking = true;
			if (_workMode == WorkMode.MultiThread) ThreadPool.QueueUserWorkItem(Init);
			while (_isWorking)
			{
				MakeCalc();
			}
		}

		private void MakeCalc()
		{
			_algorithm.DoStep();
			CommonParams.DrawQueue.Enqueue(
				new DrawInfo(GetBytes(CommonParams.SizeX, CommonParams.SizeY, CommonParams.Ez),
				_algorithm.StepNumber));
			if (CommonParams.PauseStepNum != 0 && _algorithm.StepNumber % CommonParams.PauseStepNum == 0)
			{
				Stop();
			}
		}

		private bool IsContour(int index)
		{
			return index + 3 < _contour.Length 
				&& _contour[index] == 0
				&& _contour[index + 1] == 0
				&& _contour[index + 2] == 0
				&& _contour[index + 3] == 255;
		}

		private byte[] GetBytes(int width, int height, ExtArr temp)
		{
			var rgbValues = new byte[Bytes];

			for (var y = 0; y < height; y++)
			{
				for (var x = 0; x < width; x++)
				{
					var index = y * SourceStride + x * SourcePixelSize;
					var c = IsContour(index) ? Color.Black : ColorByValue(temp[x, y]);

					rgbValues[index] = c.B;
					rgbValues[index + 1] = c.G;
					rgbValues[index + 2] = c.R;
					rgbValues[index + 3] = 255;
				}
			}

			return rgbValues;
		}
		
		private void InitColorArray()
		{
			_colors = new Color[256];
			using (var bitmap = new Bitmap(256, 1)) // 100x100 pixels
			using (var graphics = Graphics.FromImage(bitmap))
			using (var brush = new LinearGradientBrush(
				new Rectangle(0, 0, 256, 1),
				Color.White,
				Color.Black,
				LinearGradientMode.ForwardDiagonal))
			{
				brush.SetSigmaBellShape(0.5f);
				graphics.FillRectangle(brush, new Rectangle(0, 0, 256, 1));

				for (var i = 0; i < 256; i++)
					_colors[i] = bitmap.GetPixel(i, 0);
			}
		}

		private void Init(object state)
		{
			while (_isWorking)
			{
				var source = Enumerable.Range(1, 10000)
				.Select(n => n * n * n);

				source
					.AsParallel()
					.Select(n => Math.Pow(Math.Log10(Math.Pow(n, 2) / Math.PI), 5) / (Math.PI * Math.PI))
					.ToArray();
			}
		}
		
		private Color ColorByValue(decimal value)
		{
			var abs = Math.Abs(value);
			if (abs >= _max)
			{
				return Color.Black;
			}
			if (abs <= _min)
			{
				return Color.White;
			}
			return _colors[(int)Math.Round(255 * (abs - _min) / (_max - _min))];
		}

		private static decimal GetMaxValue(FieldType fieldType)
		{
			switch (fieldType)
			{
				case FieldType.EType:
					return PhisicalConstants.Ez0;
				case FieldType.DType:
					return PhisicalConstants.Ez0 * PhisicalConstants.Eps0 * RegionList.Eps;
				case FieldType.HType:
					return PhisicalConstants.Hz0;
				case FieldType.BType:
					return PhisicalConstants.Hz0 * PhisicalConstants.Mu0;
			}
			return 0.1m;
		}
	}
}