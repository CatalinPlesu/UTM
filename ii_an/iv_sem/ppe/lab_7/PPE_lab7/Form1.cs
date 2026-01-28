using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace PPE_lab7
{
    public partial class Form1 : Form
    {
        private int _ticks;
        private int score;
        public Form1()
        {
            InitializeComponent();
            this.Text = "PPE lab 7 Plesu Catalin";
            button1.Enabled = false;
        }

        private void button1_Click(object sender, EventArgs e)
        {
            finish_calculations("Felicitari");
        }

        private void finish_calculations(String msg)
        {
            score = 66;
            timer1.Stop();
            button1.Enabled = false;

            if (!radioButton2.Checked) {
                score -= 33;
            }
            if (!radioButton6.Checked) {
                score -= 33;
            }
            if (checkBox2.Checked) { score -= 5; }
            if (checkBox5.Checked) { score -= 5; }
            if (checkBox7.Checked) { score -= 5; }
            if (checkBox8.Checked) { score -= 5; }
            if (checkBox1.Checked) { score += 7; }
            if (checkBox3.Checked) { score += 5; }
            if (checkBox4.Checked) { score += 5; }
            if (checkBox6.Checked) { score += 7; }
            if (checkBox9.Checked) { score += 5; }
            if (checkBox10.Checked) { score += 5; }

            groupBox1.Dispose();
            groupBox2.Dispose();
            groupBox3.Dispose();


            Label namelablel0 = new Label();
            namelablel0.Location = new Point(15, 20);
            namelablel0.AutoSize = true;
            namelablel0.Text = msg;
            this.Controls.Add(namelablel0);

            Label namelabel = new Label();
            namelabel.Location = new Point(15, 40);
            namelabel.AutoSize = true;
            if (score < 0)
                score = 0;
            namelabel.Text = String.Concat("Punctajul obtinut este: ", score, " din 100");
            this.Controls.Add(namelabel);

            Label namelabel1 = new Label();
            namelabel1.Location = new Point(15, 60);
            namelabel1.AutoSize = true;
            namelabel1.Text = String.Concat("Testul a fost efectuat in: ", _ticks, " secunde");
            this.Controls.Add(namelabel1);
        }

        private void button2_Click(object sender, EventArgs e)
        {
            //MessageBox.Show("Veti avea la dispozitie 1 minuta dupa ce apasati ok");
            timer1.Start();
            groupBox4.Dispose();
            //groupBox4.Visible = false;

            button2.Enabled = false;
            button1.Enabled = true;
        }

        private void label1_Click(object sender, EventArgs e)
        {

        }

        private void checkBox2_CheckedChanged(object sender, EventArgs e)
        {

        }

        private void radioButton4_CheckedChanged(object sender, EventArgs e)
        {
        }

        private void checkBox3_CheckedChanged(object sender, EventArgs e)
        {

        }

        private void checkBox5_CheckedChanged(object sender, EventArgs e)
        {

        }

        private void checkBox8_CheckedChanged(object sender, EventArgs e)
        {

        }

        private void groupBox1_Enter(object sender, EventArgs e)
        {

        }

        private void Form1_Load(object sender, EventArgs e)
        {

        }

        private void radioButton7_CheckedChanged(object sender, EventArgs e)
        {

        }

        private void timer1_Tick_1(object sender, EventArgs e)
        {
            _ticks++;
            this.Text = String.Concat(_ticks.ToString(), " sec");

            if (_ticks == 60)
            {
                this.Text = "Timpul a expirat";
                timer1.Stop();
                finish_calculations("Timpul a expirat");
            }
        }

        private void radioButton1_CheckedChanged(object sender, EventArgs e)
        {
        }

        private void radioButton2_CheckedChanged(object sender, EventArgs e)
        {
        }

        private void radioButton3_CheckedChanged(object sender, EventArgs e)
        {
        }

        private void radioButton6_CheckedChanged(object sender, EventArgs e)
        {

        }

        private void checkBox2_CheckedChanged_1(object sender, EventArgs e)
        {

        }

        private void checkBox6_CheckedChanged(object sender, EventArgs e)
        {

        }

        private void groupBox5_Enter(object sender, EventArgs e)
        {

        }

        private void groupBox5_Enter_1(object sender, EventArgs e)
        {

        }
    }
}
