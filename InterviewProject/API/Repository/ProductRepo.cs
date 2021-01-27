using API.ViewModels;
using Dapper;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Threading.Tasks;

namespace API.Repository
{
    public class ProductCategoryRepo
    {
        IConfiguration _configuration;
        DynamicParameters parameters = new DynamicParameters();
        public ProductCategoryRepo(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        public async Task<IEnumerable<CategoryProductVM>> getAll()
        {
            using (SqlConnection connection = new SqlConnection(_configuration.GetConnectionString("myConn")))
            {
                var procName = "SP_CategoryProduct_GetAll";
                var getAll = await connection.QueryAsync<CategoryProductVM>(procName, commandType: CommandType.StoredProcedure);
                return getAll;
            }
        }

        public CategoryProductVM getID(int id)
        {
            using (SqlConnection connection = new SqlConnection(_configuration.GetConnectionString("myConn")))
            {
                var procName = "SP_CategoryProduct_GetID";
                parameters.Add("id", id);
                var getId = connection.Query<CategoryProductVM>(procName, parameters, commandType: CommandType.StoredProcedure).SingleOrDefault();
                return getId;
            }
        }
    }

    public class ProductRepo
    {
        IConfiguration _configuration;
        DynamicParameters parameters = new DynamicParameters();
        public ProductRepo(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        public async Task<IEnumerable<ProductVM>> getAll()
        {
            using (SqlConnection connection = new SqlConnection(_configuration.GetConnectionString("myConn")))
            {
                var procName = "SP_Product_GetAll";
                var getAll = await connection.QueryAsync<ProductVM>(procName, commandType: CommandType.StoredProcedure);
                return getAll;
            }
        }

        public ProductVM getID(int id)
        {
            using (SqlConnection connection = new SqlConnection(_configuration.GetConnectionString("myConn")))
            {
                var procName = "SP_Product_GetID";
                parameters.Add("id", id);
                var getId = connection.Query<ProductVM>(procName, parameters, commandType: CommandType.StoredProcedure).SingleOrDefault();
                return getId;
            }
        }
    }
}
