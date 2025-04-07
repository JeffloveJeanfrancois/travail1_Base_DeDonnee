using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using Travail1_Partie_4.Manager;
using Travail1_Partie_4.Models;

namespace Travail1_Partie_4
{
    public partial class RechercherModifierEmploye : Form
    {
        List<TblEmployee> employes;

        public RechercherModifierEmploye()
        {
            InitializeComponent();
        }

        private void RechercherButon_Click(object sender, EventArgs e)
        {
            string recherche = entrerNom_TextBox.Text;
            FiltrerRechercheComboBox(recherche);
            selectionnerEmploye_ComboBox.Visible = true;
        }

        private void FiltrerRechercheComboBox(string recherche)
        {
            var managerEmploye = new ManagerEmploye();
            employes = managerEmploye.ListerEmployee(recherche);
            //selectionnerEmploye_ComboBox.DataSource = employes;
            //selectionnerEmploye_ComboBox.DisplayMember = "NomComplet";
            //selectionnerEmploye_ComboBox.ValueMember = "IdEmployee"; //ce n'est pas le nom de la colonne dans la base de Donnees mais le nom de la colonne dans la classe
            //selectionnerEmploye_ComboBox.DropDownStyle = ComboBoxStyle.DropDownList;
            //selectionnerEmploye_ComboBox.SelectedValue = "";

            remplircombobox();

        }

        private void remplircombobox()
        {
            try
            {
                selectionnerEmploye_ComboBox.DataSource = employes;
                selectionnerEmploye_ComboBox.DisplayMember = "NomComplet";
                selectionnerEmploye_ComboBox.ValueMember = "idemployee"; //ce n'est pas le nom de la colonne dans la base de donnees mais le nom de la colonne dans la classe
                selectionnerEmploye_ComboBox.DropDownStyle = ComboBoxStyle.DropDownList;
                selectionnerEmploye_ComboBox.SelectedValue = "";

            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, "erreur", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void RechercherModifierEmploye_Load(object sender, EventArgs e)
        {
            selectionnerEmploye_ComboBox.Visible = false;
        }

        private void EnregistrerButon_Click(object sender, EventArgs e)
        {

        }

        private void selectionnerEmploye_ComboBox_SelectionChangeCommitted(object sender, EventArgs e)
        {
            TblEmployee employe = selectionnerEmploye_ComboBox.SelectedItem as TblEmployee;
            nom_TextBox.Text = employe.Nom;
            prenom_TextBox.Text = employe.Prenom;
            email_TextBox.Text = employe.Email;
        }

        public bool ChampsRemplit()
        {
            return (!string.IsNullOrEmpty(nom_TextBox.Text) &&
                !string.IsNullOrEmpty(prenom_TextBox.Text)
                && !string.IsNullOrEmpty(email_TextBox.Text));


        }
        private void ViderLesChamps()
        {
            nom_TextBox.Clear();
            prenom_TextBox.Clear();
            email_TextBox.Clear();
        }

        public TblEmployee RemplirLesInformations()
        {
            var employe = new TblEmployee();
            employe.Nom = nom_TextBox.Text;
            employe.Prenom = prenom_TextBox.Text;
            employe.Email = email_TextBox.Text;
            return employe;
        }

        private void modifierButon_Click(object sender, EventArgs e)
        {
            int nombreDeLigneAffectees = 0;
            TblEmployee employe;

            try
            {
                ManagerEmploye managerEmploye = new ManagerEmploye();
                if (ChampsRemplit())
                {
                    employe = RemplirLesInformations();
                    nombreDeLigneAffectees = managerEmploye.ModifierEmployee(employe);
                    if (nombreDeLigneAffectees > 0)
                    {
                        MessageBox.Show("la modification cest bien effectuee");
                        remplircombobox();
                        ViderLesChamps();
                    }
                }
                else
                {
                    MessageBox.Show("la modification a bien ete effectuee");
                }

            }
            catch (Exception ex)
            {

                MessageBox.Show(ex.Message, "Erreur", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }
    }
   
}
