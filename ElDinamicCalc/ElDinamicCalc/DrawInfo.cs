namespace ElDinamicCalc
{
	public class DrawInfo
	{
		public DrawInfo(byte[] value, int step)
		{
			Value = value;
			Step = step;
		}

		public byte[] Value { get; private set; }
		public int Step { get; private set; }
	}
}