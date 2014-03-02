using System.Drawing;

namespace ElDinamicCalc
{
	public class HalfSpace : Figure
	{
		public override int Param1 { get; set; }
		public override int Param2 { get; set; }
		public Orientation Orientation { get; set; }

		public override bool Belong(int x, int y)
		{
			switch (Orientation)
			{
				case Orientation.Left:
					return x <= X;
				case Orientation.Right:
					return x >= X;
				case Orientation.Top:
					return y <= Y;
				case Orientation.Bottom:
					return y >= Y;
			}
			return false;
		}

		public override bool BelongContour(int x, int y)
		{
			switch (Orientation)
			{
				case Orientation.Left:
					return x == X;
				case Orientation.Right:
					return x == X;
				case Orientation.Top:
					return y == Y;
				case Orientation.Bottom:
					return y == Y;
			}
			return false;
		}

		public override void Align(HorAlign horAlign, VertAlign vertAlign, int sizeX, int sizeY)
		{

		}

		public override void DrawContour(Graphics graph, int height, int width)
		{
			switch (Orientation)
			{
				case Orientation.Left:
					graph.DrawRectangle(new Pen(Color.Black, 1),
						0, 0, X, height);
					break;
				case Orientation.Right:
					graph.DrawRectangle(new Pen(Color.Black, 1),
						X, 0, width, height);
					break;
				case Orientation.Top:
					graph.DrawRectangle(new Pen(Color.Black, 1),
						0, 0, width, Y);
					break;
				case Orientation.Bottom:
					graph.DrawRectangle(new Pen(Color.Black, 1),
						0, X, width, height);
					break;
			}

			graph.Flush();
			graph.Save();
		}
	}
}