using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Travail1_Partie_4
{
    public partial class MenuForm : Form
    {
        public MenuForm()
        {
            InitializeComponent();
        }

        private void rechercherModifierToolStripMenuItem_Click(object sender, EventArgs e)
        {
            var maForme = new RechercherModifierEmploye();
            maForme.ShowDialog();
        }
    }
}
