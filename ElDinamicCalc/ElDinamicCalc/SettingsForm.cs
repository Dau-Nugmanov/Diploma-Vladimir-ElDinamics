using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
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
		}

		private void buttonSave_Click(object sender, EventArgs e)
		{
			Settings.DelT = numericUpDownDt.Value;
			Settings.DelX = numericUpDownDx.Value;
			Settings.DelY = numericUpDownDy.Value;
			Settings.PauseStepNum = Convert.ToInt32(numericUpDownStep.Value);

			DialogResult = DialogResult.OK;
			Close();
		}
	}
}