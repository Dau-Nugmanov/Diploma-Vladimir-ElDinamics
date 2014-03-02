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
			this.buttonStart = new System.Windows.Forms.Button();
			this.drawPanel = new System.Windows.Forms.Panel();
			this.timerDraw = new System.Windows.Forms.Timer(this.components);
			this.menuStrip1 = new System.Windows.Forms.MenuStrip();
			this.файлToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
			this.открытьToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
			this.выходToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
			this.настройкиToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
			this.SettingsToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
			this.toolStripComboBox = new System.Windows.Forms.ToolStripComboBox();
			this.editorStartToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
			this.openFileDialog = new System.Windows.Forms.OpenFileDialog();
			this.statusStrip = new System.Windows.Forms.StatusStrip();
			this.toolStripStatusLabel1 = new System.Windows.Forms.ToolStripStatusLabel();
			this.toolStripStatusLabelStepNum = new System.Windows.Forms.ToolStripStatusLabel();
			this.toolStripStatusLabel2 = new System.Windows.Forms.ToolStripStatusLabel();
			this.toolStripStatusLabelQueueCount = new System.Windows.Forms.ToolStripStatusLabel();
			this.toolStripStatusLabel3 = new System.Windows.Forms.ToolStripStatusLabel();
			this.toolStripStatusLabelTime = new System.Windows.Forms.ToolStripStatusLabel();
			this.menuStrip1.SuspendLayout();
			this.statusStrip.SuspendLayout();
			this.SuspendLayout();
			// 
			// buttonStart
			// 
			this.buttonStart.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
			this.buttonStart.Location = new System.Drawing.Point(935, 671);
			this.buttonStart.Name = "buttonStart";
			this.buttonStart.Size = new System.Drawing.Size(75, 23);
			this.buttonStart.TabIndex = 0;
			this.buttonStart.Text = "Start";
			this.buttonStart.UseVisualStyleBackColor = true;
			this.buttonStart.Click += new System.EventHandler(this.buttonStart_Click);
			// 
			// drawPanel
			// 
			this.drawPanel.BackColor = System.Drawing.Color.White;
			this.drawPanel.Location = new System.Drawing.Point(13, 38);
			this.drawPanel.Name = "drawPanel";
			this.drawPanel.Size = new System.Drawing.Size(995, 626);
			this.drawPanel.TabIndex = 1;
			// 
			// timerDraw
			// 
			this.timerDraw.Enabled = true;
			this.timerDraw.Interval = 1;
			this.timerDraw.Tick += new System.EventHandler(this.timerDraw_Tick);
			// 
			// menuStrip1
			// 
			this.menuStrip1.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.файлToolStripMenuItem,
            this.настройкиToolStripMenuItem});
			this.menuStrip1.Location = new System.Drawing.Point(0, 0);
			this.menuStrip1.Name = "menuStrip1";
			this.menuStrip1.Size = new System.Drawing.Size(1020, 24);
			this.menuStrip1.TabIndex = 8;
			this.menuStrip1.Text = "menuStrip1";
			// 
			// файлToolStripMenuItem
			// 
			this.файлToolStripMenuItem.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.открытьToolStripMenuItem,
            this.выходToolStripMenuItem});
			this.файлToolStripMenuItem.Name = "файлToolStripMenuItem";
			this.файлToolStripMenuItem.Size = new System.Drawing.Size(48, 20);
			this.файлToolStripMenuItem.Text = "Файл";
			// 
			// открытьToolStripMenuItem
			// 
			this.открытьToolStripMenuItem.Name = "открытьToolStripMenuItem";
			this.открытьToolStripMenuItem.Size = new System.Drawing.Size(121, 22);
			this.открытьToolStripMenuItem.Text = "Открыть";
			this.открытьToolStripMenuItem.Click += new System.EventHandler(this.fileOpenToolStripMenuItem_Click);
			// 
			// выходToolStripMenuItem
			// 
			this.выходToolStripMenuItem.Name = "выходToolStripMenuItem";
			this.выходToolStripMenuItem.Size = new System.Drawing.Size(121, 22);
			this.выходToolStripMenuItem.Text = "Выход";
			this.выходToolStripMenuItem.Click += new System.EventHandler(this.ExitToolStripMenuItem_Click);
			// 
			// настройкиToolStripMenuItem
			// 
			this.настройкиToolStripMenuItem.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.SettingsToolStripMenuItem,
            this.toolStripComboBox,
            this.editorStartToolStripMenuItem});
			this.настройкиToolStripMenuItem.Name = "настройкиToolStripMenuItem";
			this.настройкиToolStripMenuItem.Size = new System.Drawing.Size(79, 20);
			this.настройкиToolStripMenuItem.Text = "Настройки";
			// 
			// SettingsToolStripMenuItem
			// 
			this.SettingsToolStripMenuItem.Name = "SettingsToolStripMenuItem";
			this.SettingsToolStripMenuItem.Size = new System.Drawing.Size(260, 22);
			this.SettingsToolStripMenuItem.Text = "Показать";
			this.SettingsToolStripMenuItem.Click += new System.EventHandler(this.SettingsToolStripMenuItem_Click);
			// 
			// toolStripComboBox
			// 
			this.toolStripComboBox.DropDownWidth = 200;
			this.toolStripComboBox.Name = "toolStripComboBox";
			this.toolStripComboBox.Size = new System.Drawing.Size(200, 23);
			// 
			// editorStartToolStripMenuItem
			// 
			this.editorStartToolStripMenuItem.Name = "editorStartToolStripMenuItem";
			this.editorStartToolStripMenuItem.Size = new System.Drawing.Size(260, 22);
			this.editorStartToolStripMenuItem.Text = " Запуск редактора";
			this.editorStartToolStripMenuItem.Click += new System.EventHandler(this.editorStartToolStripMenuItem_Click);
			// 
			// openFileDialog
			// 
			this.openFileDialog.DefaultExt = "mdm";
			this.openFileDialog.Filter = "Файлы редактора (*.mdm)|*.mdm";
			// 
			// statusStrip
			// 
			this.statusStrip.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.toolStripStatusLabel1,
            this.toolStripStatusLabelStepNum,
            this.toolStripStatusLabel2,
            this.toolStripStatusLabelQueueCount,
            this.toolStripStatusLabel3,
            this.toolStripStatusLabelTime});
			this.statusStrip.Location = new System.Drawing.Point(0, 695);
			this.statusStrip.Name = "statusStrip";
			this.statusStrip.Size = new System.Drawing.Size(1020, 22);
			this.statusStrip.TabIndex = 9;
			this.statusStrip.Text = "statusStrip1";
			// 
			// toolStripStatusLabel1
			// 
			this.toolStripStatusLabel1.Name = "toolStripStatusLabel1";
			this.toolStripStatusLabel1.Size = new System.Drawing.Size(79, 17);
			this.toolStripStatusLabel1.Text = "Номер шага:";
			// 
			// toolStripStatusLabelStepNum
			// 
			this.toolStripStatusLabelStepNum.Name = "toolStripStatusLabelStepNum";
			this.toolStripStatusLabelStepNum.Size = new System.Drawing.Size(13, 17);
			this.toolStripStatusLabelStepNum.Text = "0";
			// 
			// toolStripStatusLabel2
			// 
			this.toolStripStatusLabel2.Name = "toolStripStatusLabel2";
			this.toolStripStatusLabel2.Size = new System.Drawing.Size(127, 17);
			this.toolStripStatusLabel2.Text = "Очередь прорисовки:";
			// 
			// toolStripStatusLabelQueueCount
			// 
			this.toolStripStatusLabelQueueCount.Name = "toolStripStatusLabelQueueCount";
			this.toolStripStatusLabelQueueCount.Size = new System.Drawing.Size(13, 17);
			this.toolStripStatusLabelQueueCount.Text = "0";
			// 
			// toolStripStatusLabel3
			// 
			this.toolStripStatusLabel3.Name = "toolStripStatusLabel3";
			this.toolStripStatusLabel3.Size = new System.Drawing.Size(89, 17);
			this.toolStripStatusLabel3.Text = "Время работы:";
			// 
			// toolStripStatusLabelTime
			// 
			this.toolStripStatusLabelTime.Name = "toolStripStatusLabelTime";
			this.toolStripStatusLabelTime.Size = new System.Drawing.Size(0, 17);
			// 
			// MainWindow
			// 
			this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
			this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
			this.ClientSize = new System.Drawing.Size(1020, 717);
			this.Controls.Add(this.statusStrip);
			this.Controls.Add(this.drawPanel);
			this.Controls.Add(this.buttonStart);
			this.Controls.Add(this.menuStrip1);
			this.MainMenuStrip = this.menuStrip1;
			this.Name = "MainWindow";
			this.Text = "ElDinamicCalc";
			this.ResizeEnd += new System.EventHandler(this.MainWindow_ResizeEnd);
			this.menuStrip1.ResumeLayout(false);
			this.menuStrip1.PerformLayout();
			this.statusStrip.ResumeLayout(false);
			this.statusStrip.PerformLayout();
			this.ResumeLayout(false);
			this.PerformLayout();

		}

		#endregion

		private System.Windows.Forms.Button buttonStart;
		private System.Windows.Forms.Panel drawPanel;
		private System.Windows.Forms.Timer timerDraw;
		private System.Windows.Forms.MenuStrip menuStrip1;
		private System.Windows.Forms.ToolStripMenuItem файлToolStripMenuItem;
		private System.Windows.Forms.ToolStripMenuItem открытьToolStripMenuItem;
		private System.Windows.Forms.ToolStripMenuItem выходToolStripMenuItem;
		private System.Windows.Forms.OpenFileDialog openFileDialog;
		private System.Windows.Forms.StatusStrip statusStrip;
		private System.Windows.Forms.ToolStripStatusLabel toolStripStatusLabel1;
		private System.Windows.Forms.ToolStripStatusLabel toolStripStatusLabelStepNum;
		private System.Windows.Forms.ToolStripStatusLabel toolStripStatusLabel2;
		private System.Windows.Forms.ToolStripStatusLabel toolStripStatusLabelQueueCount;
		private System.Windows.Forms.ToolStripMenuItem настройкиToolStripMenuItem;
		private System.Windows.Forms.ToolStripMenuItem SettingsToolStripMenuItem;
		private System.Windows.Forms.ToolStripComboBox toolStripComboBox;
		private System.Windows.Forms.ToolStripStatusLabel toolStripStatusLabel3;
		private System.Windows.Forms.ToolStripStatusLabel toolStripStatusLabelTime;
		private System.Windows.Forms.ToolStripMenuItem editorStartToolStripMenuItem;
	}
}