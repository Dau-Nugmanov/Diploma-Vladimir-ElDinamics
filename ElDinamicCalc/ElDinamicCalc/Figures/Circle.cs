using System;
using System.Drawing;

namespace ElDinamicCalc
{
	public class Circle : Figure
	{
		public override int Param1
		{
			get { return Radius; }
			set { Radius = value; }
		}

		public override int Param2
		{
			get { return Radius; }
			set { Radius = value; }
		}
		public int Radius { get; set; }
		public override bool Belong(int x, int y)
		{
			return Math.Pow(x - X, 2) + Math.Pow(y - Y, 2)
			       <= Math.Pow(Radius, 2);
		}

		public override bool BelongContour(int x, int y)
		{
			return Math.Abs(Math.Pow(x - X, 2)
			                + Math.Pow(y - Y, 2)
			                - Math.Pow(Radius, 2)) < 0.5;
		}

		public override void Align(HorAlign horAlign, VertAlign vertAlign, int sizeX, int sizeY)
		{

			switch (horAlign)
			{
				case HorAlign.Left:
					X = Radius;
					break;
				case HorAlign.Right:
					X = sizeX - Radius;
					break;
				case HorAlign.Center:
					X = sizeX % 2;
					break;
			}

			switch (vertAlign)
			{
				case VertAlign.Bottom:
					Y = sizeY - Radius;
					break;
				case VertAlign.Top:
					Y = Radius;
					break;
				case VertAlign.Center:
					Y = sizeY % 2;
					break;
			}
		}

		public override void DrawContour(Graphics graph, int height, int width)
		{
			graph.DrawEllipse(new Pen(Color.Black, 1),
				X - Radius, Y - Radius, Radius * 2, Radius * 2);
			graph.Flush();
			graph.Save();
		}
	}
}