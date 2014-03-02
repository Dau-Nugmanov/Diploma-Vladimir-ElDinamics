using System.Drawing;

namespace ElDinamicCalc
{
	public abstract class Figure
	{
		public int X { get; set; }
		public int Y { get; set; }
		public ContourShape Shape { get; set; }
		public abstract int Param1 { get; set; }
		public abstract int Param2 { get; set; }
		public abstract bool Belong(int x, int y);
		public abstract bool BelongContour(int x, int y);
		public abstract void Align(HorAlign horAlign, VertAlign vertAlign,
			int sizeX, int sizeY);
		public abstract void DrawContour(Graphics graph, int height, int width);
	}
}