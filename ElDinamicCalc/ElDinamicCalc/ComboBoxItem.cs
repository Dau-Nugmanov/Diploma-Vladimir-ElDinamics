namespace ElDinamicCalc
{
	class ComboBoxItem
	{
		public WorkMode WorkMode { get; set; }
		public override string ToString()
		{
			switch (WorkMode)
			{
				case WorkMode.SingleThread:
					return "Однопоточный режим";
				case WorkMode.MultiThread:
					return "Многопоточный режим";
			}
			return string.Empty;
		}
	}
}