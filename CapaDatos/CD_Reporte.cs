using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using CapaEntidad;
using System.Data.SqlClient;
using System.Data;
using System.Configuration;
using System.Globalization;

namespace CapaDatos
{
    public class CD_Reporte
    {
        private SqlConnection cn;
        public CD_Reporte()
        {
            cn = new SqlConnection(ConfigurationManager.ConnectionStrings["cadena"].ConnectionString);
        }

        // Listar Resportes
        public List<Reporte> Ventas(string fechainicio, string fechafin, string idtransaccion)
        {
            List<Reporte> listado = new List<Reporte>();
            SqlCommand cmd = new SqlCommand("sp_ReporteVentas", cn);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.AddWithValue("fechainicio", fechainicio);
            cmd.Parameters.AddWithValue("fechafin", fechafin);
            cmd.Parameters.AddWithValue("idtransaccion", idtransaccion);

            try
            {
                cn.Open();
                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    while (dr.Read())
                    {
                        Reporte reporte = new Reporte()
                        {
                            FechaVenta = dr["FechaVenta"].ToString(),
                            Cliente = dr["Cliente"].ToString(),
                            Producto = dr["Producto"].ToString(),
                            Precio = Convert.ToDecimal(dr["Precio"], new CultureInfo("es-PE")),
                            Cantidad = Convert.ToInt32(dr["Cantidad"].ToString()),
                            Total = Convert.ToDecimal(dr["Total"], new CultureInfo("es-PE")),
                            IdTransaccion = dr["IdTransaccion"].ToString()
                        };
                        listado.Add(reporte);
                    }
                }
            }
            catch
            {
                listado = new List<Reporte>();
            }
            return listado;
        }

        // Ver Datos DashBoard
        public DashBoard VerDashBoard()
        {
            DashBoard objeto = new DashBoard();
            SqlCommand cmd = new SqlCommand("sp_ReporteDashboard", cn);
            cmd.CommandType = CommandType.StoredProcedure;
            try
            {
                cn.Open();
                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    while (dr.Read())
                    {
                        objeto = new DashBoard()
                        {
                            TotalCliente = Convert.ToInt32(dr["TotalCliente"]),
                            TotalVenta = Convert.ToInt32(dr["TotalVenta"]),
                            TotalProducto = Convert.ToInt32(dr["TotalProducto"]),
                        };
                    }
                }
            }
            catch
            {
                objeto = new DashBoard();
            }
            return objeto;
        }


    }
}
