using System;
using System.Linq;
using System.Windows.Forms;

namespace ElDinamicCalc
{
	public partial class SettingsForm : Form
	{
		public MainSettings Settings { get; private set; }

		public SettingsForm(MainSettings settings)
		{
			Settings = settings;
			InitializeComponent();
			numericUpDownDt.Value = Settings.DelT;
			numericUpDownDt.Increment = Settings.DelT;
			numericUpDownDx.Value = Settings.DelX;
			numericUpDownDx.Increment = Settings.DelX;
			numericUpDownDy.Value = Settings.DelY;
			numericUpDownDy.Increment = Settings.DelY;
			numericUpDownDrawStep.Value = Settings.DrawStepNum;
			numericUpDownCellSize.Value = Settings.CellSize;
			comboBoxWorkMode.Items.Add(new ComboBoxItem { WorkMode = WorkMode.SingleThread });
			comboBoxWorkMode.Items.Add(new ComboBoxItem { WorkMode = WorkMode.MultiThread });
			comboBoxWorkMode.SelectedIndex = Settings.WorkMode == WorkMode.SingleThread
				? 0
				: 1;

		}

		private void buttonSave_Click(object sender, EventArgs e)
		{
			Settings.DelT = numericUpDownDt.Value;
			Settings.DelX = numericUpDownDx.Value;
			Settings.DelY = numericUpDownDy.Value;
			Settings.PauseStepNum = Convert.ToInt32(numericUpDownStep.Value);
			Settings.DrawStepNum = Convert.ToInt32(numericUpDownDrawStep.Value);
			Settings.CellSize = Convert.ToInt32(numericUpDownCellSize.Value);
			Settings.WorkMode = (comboBoxWorkMode.SelectedItem as ComboBoxItem).WorkMode;

			DialogResult = DialogResult.OK;
			Close();
		}

		private void comboBoxWorkMode_SelectedIndexChanged(object sender, EventArgs e)
		{
			numericUpDownCellSize.Visible = labelCellSize.Visible = 
				(comboBoxWorkMode.SelectedItem as ComboBoxItem).WorkMode == WorkMode.MultiThread;
		}
	}
}