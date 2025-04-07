using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using Travail1_Partie_4.Models;

namespace Travail1_Partie_4.Manager
{
    public class ManagerEmploye
    {
        public List<TblEmployee> ListerEmployee(string recherche)
        {
            using (var context = new Bd_ReseauContext())
            {
                return context.TblEmployees.Where(e => EF.Functions.Like(e.Nom, $"%{recherche}%") || EF.Functions.Like(e.Prenom, $"%{recherche}%")).ToList();
            }
        }

        public int ModifierEmployee(TblEmployee Employee)
        {
            int nombreLigneAffectee = 0;

            using(var context = new Bd_ReseauContext())
            {
                var employeModifie = context.TblEmployees.Find(Employee.IdEmployee);

                employeModifie.IdEmployee = Employee.IdEmployee;
                employeModifie.Prenom = Employee.Prenom;
                employeModifie.Nom = Employee.Nom;

                nombreLigneAffectee = context.SaveChanges();
            }

            return nombreLigneAffectee;

        }
    }
}
