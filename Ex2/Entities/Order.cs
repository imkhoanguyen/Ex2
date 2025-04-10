using System.ComponentModel.DataAnnotations;

namespace Ex2.Entities
{
    public class Order
    {
        [Key]
        public int OrderId { get; set; }
        public int CustomerId { get; set; }
        public DateTime OrderDate { get; set; } = DateTime.Now;
        public required string Status { get; set; }
        public Customer? Customer { get; set; }
        public List<OrderItems> Items { get; set; } = [];
    }
}
