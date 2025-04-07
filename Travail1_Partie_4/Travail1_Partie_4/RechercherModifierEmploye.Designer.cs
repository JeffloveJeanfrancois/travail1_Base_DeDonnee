namespace Travail1_Partie_4
{
    partial class RechercherModifierEmploye
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
            Recherche = new GroupBox();
            RechercherButon = new Button();
            selectionnerEmploye_ComboBox = new ComboBox();
            entrerNom_TextBox = new TextBox();
            label3 = new Label();
            label2 = new Label();
            Modifier = new GroupBox();
            modifierButon = new Button();
            email_TextBox = new TextBox();
            prenom_TextBox = new TextBox();
            nom_TextBox = new TextBox();
            no_employer_TextBox = new TextBox();
            label4 = new Label();
            label5 = new Label();
            label6 = new Label();
            label7 = new Label();
            Recherche.SuspendLayout();
            Modifier.SuspendLayout();
            SuspendLayout();
            // 
            // Recherche
            // 
            Recherche.Controls.Add(RechercherButon);
            Recherche.Controls.Add(selectionnerEmploye_ComboBox);
            Recherche.Controls.Add(entrerNom_TextBox);
            Recherche.Controls.Add(label3);
            Recherche.Controls.Add(label2);
            Recherche.Location = new Point(12, 12);
            Recherche.Name = "Recherche";
            Recherche.Size = new Size(760, 197);
            Recherche.TabIndex = 0;
            Recherche.TabStop = false;
            Recherche.Text = "Recherche un employer";
            // 
            // RechercherButon
            // 
            RechercherButon.Location = new Point(546, 94);
            RechercherButon.Name = "RechercherButon";
            RechercherButon.Size = new Size(175, 23);
            RechercherButon.TabIndex = 5;
            RechercherButon.Text = "Rechercher employer";
            RechercherButon.UseVisualStyleBackColor = true;
            RechercherButon.Click += RechercherButon_Click;
            // 
            // selectionnerEmploye_ComboBox
            // 
            selectionnerEmploye_ComboBox.FormattingEnabled = true;
            selectionnerEmploye_ComboBox.Location = new Point(243, 144);
            selectionnerEmploye_ComboBox.Name = "selectionnerEmploye_ComboBox";
            selectionnerEmploye_ComboBox.Size = new Size(478, 23);
            selectionnerEmploye_ComboBox.TabIndex = 4;
            selectionnerEmploye_ComboBox.SelectionChangeCommitted += selectionnerEmploye_ComboBox_SelectionChangeCommitted;
            // 
            // entrerNom_TextBox
            // 
            entrerNom_TextBox.Location = new Point(243, 47);
            entrerNom_TextBox.Name = "entrerNom_TextBox";
            entrerNom_TextBox.Size = new Size(478, 23);
            entrerNom_TextBox.TabIndex = 3;
            // 
            // label3
            // 
            label3.AutoSize = true;
            label3.Location = new Point(37, 50);
            label3.Name = "label3";
            label3.Size = new Size(200, 15);
            label3.TabIndex = 2;
            label3.Text = "Entrer une partie de nom ou prenom";
            // 
            // label2
            // 
            label2.AutoSize = true;
            label2.Location = new Point(37, 152);
            label2.Name = "label2";
            label2.Size = new Size(127, 15);
            label2.TabIndex = 1;
            label2.Text = "Selectionner l'employe";
            // 
            // Modifier
            // 
            Modifier.Controls.Add(modifierButon);
            Modifier.Controls.Add(email_TextBox);
            Modifier.Controls.Add(prenom_TextBox);
            Modifier.Controls.Add(nom_TextBox);
            Modifier.Controls.Add(no_employer_TextBox);
            Modifier.Controls.Add(label4);
            Modifier.Controls.Add(label5);
            Modifier.Controls.Add(label6);
            Modifier.Controls.Add(label7);
            Modifier.Location = new Point(12, 215);
            Modifier.Name = "Modifier";
            Modifier.Size = new Size(760, 223);
            Modifier.TabIndex = 1;
            Modifier.TabStop = false;
            Modifier.Text = "Modifier un employer";
            // 
            // modifierButon
            // 
            modifierButon.Location = new Point(483, 184);
            modifierButon.Name = "modifierButon";
            modifierButon.Size = new Size(238, 23);
            modifierButon.TabIndex = 6;
            modifierButon.Text = "Enregistrer Modification";
            modifierButon.UseVisualStyleBackColor = true;
            modifierButon.Click += modifierButon_Click;
            // 
            // email_TextBox
            // 
            email_TextBox.Location = new Point(88, 145);
            email_TextBox.Name = "email_TextBox";
            email_TextBox.Size = new Size(633, 23);
            email_TextBox.TabIndex = 4;
            // 
            // prenom_TextBox
            // 
            prenom_TextBox.Location = new Point(110, 103);
            prenom_TextBox.Name = "prenom_TextBox";
            prenom_TextBox.Size = new Size(600, 23);
            prenom_TextBox.TabIndex = 5;
            // 
            // nom_TextBox
            // 
            nom_TextBox.Location = new Point(110, 67);
            nom_TextBox.Name = "nom_TextBox";
            nom_TextBox.Size = new Size(600, 23);
            nom_TextBox.TabIndex = 6;
            // 
            // no_employer_TextBox
            // 
            no_employer_TextBox.Location = new Point(110, 29);
            no_employer_TextBox.Name = "no_employer_TextBox";
            no_employer_TextBox.Size = new Size(600, 23);
            no_employer_TextBox.TabIndex = 7;
            // 
            // label4
            // 
            label4.AutoSize = true;
            label4.Location = new Point(17, 148);
            label4.Name = "label4";
            label4.Size = new Size(36, 15);
            label4.TabIndex = 3;
            label4.Text = "Email";
            // 
            // label5
            // 
            label5.AutoSize = true;
            label5.Location = new Point(17, 103);
            label5.Name = "label5";
            label5.Size = new Size(49, 15);
            label5.TabIndex = 4;
            label5.Text = "Prenom";
            // 
            // label6
            // 
            label6.AutoSize = true;
            label6.Location = new Point(17, 64);
            label6.Name = "label6";
            label6.Size = new Size(34, 15);
            label6.TabIndex = 5;
            label6.Text = "Nom";
            // 
            // label7
            // 
            label7.AutoSize = true;
            label7.Location = new Point(17, 37);
            label7.Name = "label7";
            label7.Size = new Size(76, 15);
            label7.TabIndex = 6;
            label7.Text = "No employer";
            // 
            // RechercherModifierEmploye
            // 
            AutoScaleDimensions = new SizeF(7F, 15F);
            AutoScaleMode = AutoScaleMode.Font;
            ClientSize = new Size(800, 450);
            Controls.Add(Modifier);
            Controls.Add(Recherche);
            Name = "RechercherModifierEmploye";
            Text = "RechercherModifierEmploye";
            Load += RechercherModifierEmploye_Load;
            Recherche.ResumeLayout(false);
            Recherche.PerformLayout();
            Modifier.ResumeLayout(false);
            Modifier.PerformLayout();
            ResumeLayout(false);
        }

        #endregion

        private GroupBox Recherche;
        private GroupBox Modifier;
        private ComboBox selectionnerEmploye_ComboBox;
        private TextBox entrerNom_TextBox;
        private Label label3;
        private Label label2;
        private TextBox email_TextBox;
        private TextBox prenom_TextBox;
        private TextBox nom_TextBox;
        private TextBox no_employer_TextBox;
        private Label label4;
        private Label label5;
        private Label label6;
        private Label label7;
        private Button RechercherButon;
        private Button modifierButon;
    }
}