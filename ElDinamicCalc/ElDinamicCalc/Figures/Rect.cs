using System.Drawing;

namespace ElDinamicCalc
{
	public class Rect : Figure
	{
		public int Width { get; set; }
		public int Height { get; set; }

		public override int Param1
		{
			get { return Width; }
			set
			{
				Width = value;
			}
		}
		public override int Param2
		{
			get { return Height; }
			set
			{
				Height = value;
			}
		}

		public override bool Belong(int x, int y)
		{
			return (x >= X) && (x < X + Width) &&
			       (y >= Y) && (y < Y + Height);
		}

		public override bool BelongContour(int x, int y)
		{
			return (x == X) || (x == X + Width) ||
			       (y == Y) || (y == Y + Height);
		}

		public override void Align(HorAlign horAlign, VertAlign vertAlign, int sizeX, int sizeY)
		{
			switch (horAlign)
			{
				case HorAlign.Left:
					X = 0;
					break;
				case HorAlign.Right:
					X = sizeX - Width;
					break;
				case HorAlign.Center:
					X = sizeX % 2 - Width % 2;
					break;
			}
			switch (vertAlign)
			{
				case VertAlign.Bottom:
					Y = sizeY - Height;
					break;
				case VertAlign.Top:
					Y = 0;
					break;
				case VertAlign.Center:
					Y = sizeY % 2 - Height % 2;
					break;
			}
		}

		public override void DrawContour(Graphics graph, int height, int width)
		{
			graph.DrawRectangle(new Pen(Color.Black, 1), X, Y, Width, Height);
			graph.Flush();
			graph.Save();
		}
	}
}