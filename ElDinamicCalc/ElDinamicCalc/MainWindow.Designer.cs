namespace ElDinamicCalc
{
	partial class MainWindow
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
			this.components = new System.ComponentModel.Container();
			this.button1 = new System.Windows.Forms.Button();
			this.drawPanel = new System.Windows.Forms.Panel();
			this.tbStep = new System.Windows.Forms.TextBox();
			this.timerDraw = new System.Windows.Forms.Timer(this.components);
			this.SuspendLayout();
			// 
			// button1
			// 
			this.button1.Location = new System.Drawing.Point(712, 732);
			this.button1.Name = "button1";
			this.button1.Size = new System.Drawing.Size(75, 23);
			this.button1.TabIndex = 0;
			this.button1.Text = "button1";
			this.button1.UseVisualStyleBackColor = true;
			this.button1.Click += new System.EventHandler(this.button1_Click);
			// 
			// drawPanel
			// 
			this.drawPanel.Location = new System.Drawing.Point(13, 13);
			this.drawPanel.Name = "drawPanel";
			this.drawPanel.Size = new System.Drawing.Size(774, 484);
			this.drawPanel.TabIndex = 1;
			this.drawPanel.Paint += new System.Windows.Forms.PaintEventHandler(this.drawPanel_Paint);
			// 
			// tbStep
			// 
			this.tbStep.Location = new System.Drawing.Point(686, 525);
			this.tbStep.Name = "tbStep";
			this.tbStep.Size = new System.Drawing.Size(100, 20);
			this.tbStep.TabIndex = 2;
			// 
			// timerDraw
			// 
			this.timerDraw.Enabled = true;
			this.timerDraw.Interval = 10;
			this.timerDraw.Tick += new System.EventHandler(this.timerDraw_Tick);
			// 
			// MainWindow
			// 
			this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
			this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
			this.ClientSize = new System.Drawing.Size(799, 767);
			this.Controls.Add(this.tbStep);
			this.Controls.Add(this.drawPanel);
			this.Controls.Add(this.button1);
			this.Name = "MainWindow";
			this.Text = "MainWindowcs";
			this.ResumeLayout(false);
			this.PerformLayout();

		}

		#endregion

		private System.Windows.Forms.Button button1;
		private System.Windows.Forms.Panel drawPanel;
		private System.Windows.Forms.TextBox tbStep;
		private System.Windows.Forms.Timer timerDraw;
	}
}