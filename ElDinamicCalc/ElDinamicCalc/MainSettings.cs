namespace ElDinamicCalc
{
	public class MainSettings
	{
		public decimal DelX = CommonParams.DelX0;
		public decimal DelY = CommonParams.DelY0;
		public decimal DelT = CommonParams.DelT0;
		public int PauseStepNum = 0;
		public int DrawStepNum = 1;
		public int CellSize = 10;
		public WorkMode WorkMode = WorkMode.SingleThread;
	}
}