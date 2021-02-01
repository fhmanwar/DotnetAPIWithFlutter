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
    public class CartRepo
    {
        IConfiguration _configuration;
        DynamicParameters parameters = new DynamicParameters();
        public CartRepo(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        public async Task<IEnumerable<CartVM>> getAll()
        {
            using (SqlConnection connection = new SqlConnection(_configuration.GetConnectionString("myConn")))
            {
                var procName = "SP_Cart_GetAll";
                var getAll = await connection.QueryAsync<CartVM>(procName, commandType: CommandType.StoredProcedure);
                return getAll;
            }
        }

        public CartVM getID(int id)
        {
            using (SqlConnection connection = new SqlConnection(_configuration.GetConnectionString("myConn")))
            {
                var procName = "SP_Cart_GetID";
                parameters.Add("id", id);
                var getId = connection.Query<CartVM>(procName, parameters, commandType: CommandType.StoredProcedure).SingleOrDefault();
                return getId;
            }
        }
    }

    public class TransactionRepo
    {
        IConfiguration _configuration;
        DynamicParameters parameters = new DynamicParameters();
        public TransactionRepo(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        public async Task<IEnumerable<TransactionVM>> getAll()
        {
            using (SqlConnection connection = new SqlConnection(_configuration.GetConnectionString("myConn")))
            {
                var procName = "SP_Transaction_GetAll";
                var getAll = await connection.QueryAsync<TransactionVM>(procName, commandType: CommandType.StoredProcedure);
                return getAll;
            }
        }

        public TransactionVM getID(int id)
        {
            using (SqlConnection connection = new SqlConnection(_configuration.GetConnectionString("myConn")))
            {
                var procName = "SP_Transaction_GetID";
                parameters.Add("id", id);
                var getId = connection.Query<TransactionVM>(procName, parameters, commandType: CommandType.StoredProcedure).SingleOrDefault();
                return getId;
            }
        }

        public int Create(TransactionVM dataVM)
        {
            using (SqlConnection connection = new SqlConnection(_configuration.GetConnectionString("myConn")))
            {
                var procName = "SP_Transaction_Create";
                parameters.Add("UserId", dataVM.UserId);
                parameters.Add("OrderDate", DateTimeOffset.Now);
                parameters.Add("Total", dataVM.Total);
                var insert = connection.Execute(procName, parameters, commandType: CommandType.StoredProcedure);
                return insert;
            }
        }
    }

    public class TransactionItemRepo
    {
        IConfiguration _configuration;
        DynamicParameters parameters = new DynamicParameters();
        public TransactionItemRepo(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        public async Task<IEnumerable<TransactionItemVM>> getAll()
        {
            using (SqlConnection connection = new SqlConnection(_configuration.GetConnectionString("myConn")))
            {
                var procName = "SP_TransactionItem_GetAll";
                var getAll = await connection.QueryAsync<TransactionItemVM>(procName, commandType: CommandType.StoredProcedure);
                return getAll;
            }
        }

        public TransactionItemVM getID(int id)
        {
            using (SqlConnection connection = new SqlConnection(_configuration.GetConnectionString("myConn")))
            {
                var procName = "SP_TransactionItem_GetID";
                parameters.Add("id", id);
                var getId = connection.Query<TransactionItemVM>(procName, parameters, commandType: CommandType.StoredProcedure).SingleOrDefault();
                return getId;
            }
        }
    }
}
