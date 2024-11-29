using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using CapaEntidad;
using System.Data;

namespace CapaDatos
{
    public class CD_Ubicacion
    {
        private SqlConnection cn;
        public CD_Ubicacion()
        {
            cn = new SqlConnection(ConfigurationManager.ConnectionStrings["cadena"].ConnectionString);
        }

        public List<Departamento> ObtenerDepartamento()
        {
            List<Departamento> listado = new List<Departamento>();
            SqlCommand cmd = new SqlCommand("ListarDepartamento", cn);
            cmd.CommandType = CommandType.StoredProcedure;
            try
            {
                cn.Open();
                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    while (dr.Read())
                    {
                        Departamento departamento = new Departamento()
                        {
                            IdDepartamento = dr["IdDepartamento"].ToString(),
                            Descripcion = dr["Descripcion"].ToString()
                        };
                        listado.Add(departamento);
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                if (cn.State == ConnectionState.Open)
                    cn.Close();
            }
            return listado;
        }

        public List<Provincia> ObtenerProvincia(string iddepartamento)
        {
            List<Provincia> listado = new List<Provincia>();
            SqlCommand cmd = new SqlCommand("sp_OptenerProvincia", cn);
            cmd.Parameters.AddWithValue("@IdDepartamento", iddepartamento);
            cmd.CommandType = CommandType.StoredProcedure;
            try
            {
                cn.Open();
                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    while (dr.Read())
                    {
                        Provincia provincia = new Provincia()
                        {
                            IdProvincia = dr["IdProvincia"].ToString(),
                            Descripcion = dr["Descripcion"].ToString()
                        };
                        listado.Add(provincia);
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                if (cn.State == ConnectionState.Open)
                    cn.Close();
            }
            return listado;
        }

        public List<Distrito> ObtenerDistrito(string iddepartamernto, string idprovincia)
        {
            List<Distrito> listado = new List<Distrito>();
            SqlCommand cmd = new SqlCommand("sp_ObtenerDistrito", cn);
            cmd.Parameters.AddWithValue("@IdDepartamento", iddepartamernto);
            cmd.Parameters.AddWithValue("@IdProvincia", idprovincia);
            cmd.CommandType = CommandType.StoredProcedure;
            try
            {
                cn.Open();
                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    while (dr.Read())
                    {
                        Distrito distrito = new Distrito()
                        {
                            IdDistrito = dr["IdDistrito"].ToString(),
                            Descripcion = dr["Descripcion"].ToString()
                        };
                        listado.Add(distrito);
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                if (cn.State == ConnectionState.Open)
                    cn.Close();
            }
            return listado;
        }

    }
}
