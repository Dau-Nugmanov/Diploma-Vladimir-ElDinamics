namespace ElDinamicCalc
{
	partial class SettingsForm
	{
		/// <summary>
		/// Required designer variable.
		/// </summary>
		private System.ComponentModel.IContainer components = null;

		/// <summary>
		/// Clean up any resources being used.
		/// </summary>
		/// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
		protected override void Dispose(bool disposing)
		{
			if (disposing && (components != null))
			{
				components.Dispose();
			}
			base.Dispose(disposing);
		}

		#region Windows Form Designer generated code

		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{
			this.tabControl = new System.Windows.Forms.TabControl();
			this.tabPage1 = new System.Windows.Forms.TabPage();
			this.tableLayoutPanel1 = new System.Windows.Forms.TableLayoutPanel();
			this.label4 = new System.Windows.Forms.Label();
			this.label2 = new System.Windows.Forms.Label();
			this.numericUpDownDx = new System.Windows.Forms.NumericUpDown();
			this.label1 = new System.Windows.Forms.Label();
			this.numericUpDownDt = new System.Windows.Forms.NumericUpDown();
			this.label3 = new System.Windows.Forms.Label();
			this.numericUpDownDy = new System.Windows.Forms.NumericUpDown();
			this.numericUpDownStep = new System.Windows.Forms.NumericUpDown();
			this.label5 = new System.Windows.Forms.Label();
			this.numericUpDownDrawStep = new System.Windows.Forms.NumericUpDown();
			this.labelCellSize = new System.Windows.Forms.Label();
			this.label7 = new System.Windows.Forms.Label();
			this.numericUpDownCellSize = new System.Windows.Forms.NumericUpDown();
			this.comboBoxWorkMode = new System.Windows.Forms.ComboBox();
			this.buttonSave = new System.Windows.Forms.Button();
			this.tabControl.SuspendLayout();
			this.tabPage1.SuspendLayout();
			this.tableLayoutPanel1.SuspendLayout();
			((System.ComponentModel.ISupportInitialize)(this.numericUpDownDx)).BeginInit();
			((System.ComponentModel.ISupportInitialize)(this.numericUpDownDt)).BeginInit();
			((System.ComponentModel.ISupportInitialize)(this.numericUpDownDy)).BeginInit();
			((System.ComponentModel.ISupportInitialize)(this.numericUpDownStep)).BeginInit();
			((System.ComponentModel.ISupportInitialize)(this.numericUpDownDrawStep)).BeginInit();
			((System.ComponentModel.ISupportInitialize)(this.numericUpDownCellSize)).BeginInit();
			this.SuspendLayout();
			// 
			// tabControl
			// 
			this.tabControl.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
			this.tabControl.Controls.Add(this.tabPage1);
			this.tabControl.Location = new System.Drawing.Point(15, 11);
			this.tabControl.Name = "tabControl";
			this.tabControl.SelectedIndex = 0;
			this.tabControl.Size = new System.Drawing.Size(515, 363);
			this.tabControl.TabIndex = 0;
			// 
			// tabPage1
			// 
			this.tabPage1.Controls.Add(this.tableLayoutPanel1);
			this.tabPage1.Location = new System.Drawing.Point(4, 22);
			this.tabPage1.Name = "tabPage1";
			this.tabPage1.Padding = new System.Windows.Forms.Padding(3);
			this.tabPage1.Size = new System.Drawing.Size(507, 337);
			this.tabPage1.TabIndex = 0;
			this.tabPage1.Text = "Параметры модели";
			this.tabPage1.UseVisualStyleBackColor = true;
			// 
			// tableLayoutPanel1
			// 
			this.tableLayoutPanel1.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
			this.tableLayoutPanel1.ColumnCount = 2;
			this.tableLayoutPanel1.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle());
			this.tableLayoutPanel1.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 100F));
			this.tableLayoutPanel1.Controls.Add(this.label4, 0, 3);
			this.tableLayoutPanel1.Controls.Add(this.label2, 0, 1);
			this.tableLayoutPanel1.Controls.Add(this.numericUpDownDx, 1, 1);
			this.tableLayoutPanel1.Controls.Add(this.label1, 0, 0);
			this.tableLayoutPanel1.Controls.Add(this.numericUpDownDt, 1, 0);
			this.tableLayoutPanel1.Controls.Add(this.label3, 0, 2);
			this.tableLayoutPanel1.Controls.Add(this.numericUpDownDy, 1, 2);
			this.tableLayoutPanel1.Controls.Add(this.numericUpDownStep, 1, 3);
			this.tableLayoutPanel1.Controls.Add(this.label5, 0, 4);
			this.tableLayoutPanel1.Controls.Add(this.numericUpDownDrawStep, 1, 4);
			this.tableLayoutPanel1.Controls.Add(this.labelCellSize, 0, 6);
			this.tableLayoutPanel1.Controls.Add(this.label7, 0, 5);
			this.tableLayoutPanel1.Controls.Add(this.numericUpDownCellSize, 1, 6);
			this.tableLayoutPanel1.Controls.Add(this.comboBoxWorkMode, 1, 5);
			this.tableLayoutPanel1.Location = new System.Drawing.Point(5, 5);
			this.tableLayoutPanel1.Margin = new System.Windows.Forms.Padding(2);
			this.tableLayoutPanel1.Name = "tableLayoutPanel1";
			this.tableLayoutPanel1.RowCount = 7;
			this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 14.28571F));
			this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 14.28571F));
			this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 14.28571F));
			this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 14.28571F));
			this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 14.28571F));
			this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 14.28571F));
			this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 14.28571F));
			this.tableLayoutPanel1.Size = new System.Drawing.Size(499, 327);
			this.tableLayoutPanel1.TabIndex = 2;
			// 
			// label4
			// 
			this.label4.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Left | System.Windows.Forms.AnchorStyles.Right)));
			this.label4.AutoSize = true;
			this.label4.Location = new System.Drawing.Point(2, 154);
			this.label4.Margin = new System.Windows.Forms.Padding(2, 0, 2, 0);
			this.label4.Name = "label4";
			this.label4.Size = new System.Drawing.Size(86, 13);
			this.label4.TabIndex = 6;
			this.label4.Text = "Шаг для паузы";
			// 
			// label2
			// 
			this.label2.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Left | System.Windows.Forms.AnchorStyles.Right)));
			this.label2.AutoSize = true;
			this.label2.Location = new System.Drawing.Point(2, 62);
			this.label2.Margin = new System.Windows.Forms.Padding(2, 0, 2, 0);
			this.label2.Name = "label2";
			this.label2.Size = new System.Drawing.Size(86, 13);
			this.label2.TabIndex = 2;
			this.label2.Text = "dx";
			// 
			// numericUpDownDx
			// 
			this.numericUpDownDx.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Left | System.Windows.Forms.AnchorStyles.Right)));
			this.numericUpDownDx.AutoSize = true;
			this.numericUpDownDx.DecimalPlaces = 20;
			this.numericUpDownDx.Location = new System.Drawing.Point(92, 59);
			this.numericUpDownDx.Margin = new System.Windows.Forms.Padding(2);
			this.numericUpDownDx.Name = "numericUpDownDx";
			this.numericUpDownDx.Size = new System.Drawing.Size(405, 20);
			this.numericUpDownDx.TabIndex = 3;
			// 
			// label1
			// 
			this.label1.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Left | System.Windows.Forms.AnchorStyles.Right)));
			this.label1.AutoSize = true;
			this.label1.Location = new System.Drawing.Point(2, 16);
			this.label1.Margin = new System.Windows.Forms.Padding(2, 0, 2, 0);
			this.label1.Name = "label1";
			this.label1.Size = new System.Drawing.Size(86, 13);
			this.label1.TabIndex = 0;
			this.label1.Text = "dt";
			// 
			// numericUpDownDt
			// 
			this.numericUpDownDt.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Left | System.Windows.Forms.AnchorStyles.Right)));
			this.numericUpDownDt.AutoSize = true;
			this.numericUpDownDt.DecimalPlaces = 20;
			this.numericUpDownDt.Location = new System.Drawing.Point(92, 13);
			this.numericUpDownDt.Margin = new System.Windows.Forms.Padding(2);
			this.numericUpDownDt.Name = "numericUpDownDt";
			this.numericUpDownDt.Size = new System.Drawing.Size(405, 20);
			this.numericUpDownDt.TabIndex = 1;
			// 
			// label3
			// 
			this.label3.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Left | System.Windows.Forms.AnchorStyles.Right)));
			this.label3.AutoSize = true;
			this.label3.Location = new System.Drawing.Point(2, 108);
			this.label3.Margin = new System.Windows.Forms.Padding(2, 0, 2, 0);
			this.label3.Name = "label3";
			this.label3.Size = new System.Drawing.Size(86, 13);
			this.label3.TabIndex = 4;
			this.label3.Text = "dy";
			// 
			// numericUpDownDy
			// 
			this.numericUpDownDy.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Left | System.Windows.Forms.AnchorStyles.Right)));
			this.numericUpDownDy.AutoSize = true;
			this.numericUpDownDy.DecimalPlaces = 20;
			this.numericUpDownDy.Location = new System.Drawing.Point(92, 105);
			this.numericUpDownDy.Margin = new System.Windows.Forms.Padding(2);
			this.numericUpDownDy.Name = "numericUpDownDy";
			this.numericUpDownDy.Size = new System.Drawing.Size(405, 20);
			this.numericUpDownDy.TabIndex = 5;
			// 
			// numericUpDownStep
			// 
			this.numericUpDownStep.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Left | System.Windows.Forms.AnchorStyles.Right)));
			this.numericUpDownStep.AutoSize = true;
			this.numericUpDownStep.Location = new System.Drawing.Point(92, 151);
			this.numericUpDownStep.Margin = new System.Windows.Forms.Padding(2);
			this.numericUpDownStep.Maximum = new decimal(new int[] {
            10000,
            0,
            0,
            0});
			this.numericUpDownStep.Name = "numericUpDownStep";
			this.numericUpDownStep.Size = new System.Drawing.Size(405, 20);
			this.numericUpDownStep.TabIndex = 7;
			// 
			// label5
			// 
			this.label5.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Left | System.Windows.Forms.AnchorStyles.Right)));
			this.label5.AutoSize = true;
			this.label5.Location = new System.Drawing.Point(3, 200);
			this.label5.Name = "label5";
			this.label5.Size = new System.Drawing.Size(84, 13);
			this.label5.TabIndex = 8;
			this.label5.Text = "Шаг отрисовки";
			this.label5.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
			// 
			// numericUpDownDrawStep
			// 
			this.numericUpDownDrawStep.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Left | System.Windows.Forms.AnchorStyles.Right)));
			this.numericUpDownDrawStep.Location = new System.Drawing.Point(93, 197);
			this.numericUpDownDrawStep.Maximum = new decimal(new int[] {
            2000,
            0,
            0,
            0});
			this.numericUpDownDrawStep.Name = "numericUpDownDrawStep";
			this.numericUpDownDrawStep.Size = new System.Drawing.Size(403, 20);
			this.numericUpDownDrawStep.TabIndex = 9;
			this.numericUpDownDrawStep.Value = new decimal(new int[] {
            1,
            0,
            0,
            0});
			// 
			// labelCellSize
			// 
			this.labelCellSize.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Left | System.Windows.Forms.AnchorStyles.Right)));
			this.labelCellSize.AutoSize = true;
			this.labelCellSize.Location = new System.Drawing.Point(3, 295);
			this.labelCellSize.Name = "labelCellSize";
			this.labelCellSize.Size = new System.Drawing.Size(84, 13);
			this.labelCellSize.TabIndex = 10;
			this.labelCellSize.Text = "Размер ячейки";
			// 
			// label7
			// 
			this.label7.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Left | System.Windows.Forms.AnchorStyles.Right)));
			this.label7.AutoSize = true;
			this.label7.Location = new System.Drawing.Point(3, 246);
			this.label7.Name = "label7";
			this.label7.Size = new System.Drawing.Size(84, 13);
			this.label7.TabIndex = 11;
			this.label7.Text = "Режим работы";
			// 
			// numericUpDownCellSize
			// 
			this.numericUpDownCellSize.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Left | System.Windows.Forms.AnchorStyles.Right)));
			this.numericUpDownCellSize.Location = new System.Drawing.Point(93, 291);
			this.numericUpDownCellSize.Name = "numericUpDownCellSize";
			this.numericUpDownCellSize.Size = new System.Drawing.Size(403, 20);
			this.numericUpDownCellSize.TabIndex = 12;
			this.numericUpDownCellSize.Value = new decimal(new int[] {
            10,
            0,
            0,
            0});
			// 
			// comboBoxWorkMode
			// 
			this.comboBoxWorkMode.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Left | System.Windows.Forms.AnchorStyles.Right)));
			this.comboBoxWorkMode.FormattingEnabled = true;
			this.comboBoxWorkMode.Location = new System.Drawing.Point(93, 242);
			this.comboBoxWorkMode.Name = "comboBoxWorkMode";
			this.comboBoxWorkMode.Size = new System.Drawing.Size(403, 21);
			this.comboBoxWorkMode.TabIndex = 13;
			this.comboBoxWorkMode.SelectedIndexChanged += new System.EventHandler(this.comboBoxWorkMode_SelectedIndexChanged);
			// 
			// buttonSave
			// 
			this.buttonSave.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
			this.buttonSave.Location = new System.Drawing.Point(462, 379);
			this.buttonSave.Margin = new System.Windows.Forms.Padding(2);
			this.buttonSave.Name = "buttonSave";
			this.buttonSave.Size = new System.Drawing.Size(69, 24);
			this.buttonSave.TabIndex = 1;
			this.buttonSave.Text = "Сохранить";
			this.buttonSave.UseVisualStyleBackColor = true;
			this.buttonSave.Click += new System.EventHandler(this.buttonSave_Click);
			// 
			// SettingsForm
			// 
			this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
			this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
			this.ClientSize = new System.Drawing.Size(540, 412);
			this.Controls.Add(this.buttonSave);
			this.Controls.Add(this.tabControl);
			this.Name = "SettingsForm";
			this.Text = "Настройки";
			this.tabControl.ResumeLayout(false);
			this.tabPage1.ResumeLayout(false);
			this.tableLayoutPanel1.ResumeLayout(false);
			this.tableLayoutPanel1.PerformLayout();
			((System.ComponentModel.ISupportInitialize)(this.numericUpDownDx)).EndInit();
			((System.ComponentModel.ISupportInitialize)(this.numericUpDownDt)).EndInit();
			((System.ComponentModel.ISupportInitialize)(this.numericUpDownDy)).EndInit();
			((System.ComponentModel.ISupportInitialize)(this.numericUpDownStep)).EndInit();
			((System.ComponentModel.ISupportInitialize)(this.numericUpDownDrawStep)).EndInit();
			((System.ComponentModel.ISupportInitialize)(this.numericUpDownCellSize)).EndInit();
			this.ResumeLayout(false);

		}

		#endregion

		private System.Windows.Forms.TabControl tabControl;
		private System.Windows.Forms.TabPage tabPage1;
		private System.Windows.Forms.TableLayoutPanel tableLayoutPanel1;
		private System.Windows.Forms.Label label1;
		private System.Windows.Forms.Label label3;
		private System.Windows.Forms.Label label2;
		private System.Windows.Forms.NumericUpDown numericUpDownDx;
		private System.Windows.Forms.NumericUpDown numericUpDownDt;
		private System.Windows.Forms.NumericUpDown numericUpDownDy;
		private System.Windows.Forms.Button buttonSave;
		private System.Windows.Forms.Label label4;
		private System.Windows.Forms.NumericUpDown numericUpDownStep;
		private System.Windows.Forms.Label label5;
		private System.Windows.Forms.NumericUpDown numericUpDownDrawStep;
		private System.Windows.Forms.Label labelCellSize;
		private System.Windows.Forms.Label label7;
		private System.Windows.Forms.NumericUpDown numericUpDownCellSize;
		private System.Windows.Forms.ComboBox comboBoxWorkMode;
	}
}