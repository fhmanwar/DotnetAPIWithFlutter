using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace API.ViewModels
{
    public class TransactionVM
    {
        public int Id { get; set; }
        public int UserId { get; set; }
        public string UserName { get; set; }
        public DateTimeOffset OrderDate { get; set; }
        public int Total { get; set; }

        public List<TransactionItemVM> transactionItems { get; set; }
    }

    public class TransactionItemVM
    {
        public int TransactionItemId { get; set; }
        public int TransactionId { get; set; }
        public int ProductId { get; set; }
        public string ProductName { get; set; }
        public string CategoryName { get; set; }
        public int Quantity { get; set; }
        public int SubTotal { get; set; }
    }

    public class CartVM
    {
        public int Id { get; set; }
        public int UserId { get; set; }
        public string UserName { get; set; }
        public int ProductId { get; set; }
        public string ProductName { get; set; }
        public int ProductPrice { get; set; }
        public string CategoryName { get; set; }
        public int Quantity { get; set; }
        public int SubTotal { get; set; }
    }

    public class getCartVM
    {
        public int UserId { get; set; }
        public string ProductName { get; set; }
        public int Quantity { get; set; }
        public int SubTotal { get; set; }
    }
}
