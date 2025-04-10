using System.ComponentModel.DataAnnotations;

namespace Ex2.Entities
{
    public class Shipment
    {
        [Key]
        public int ShipmentId { get; set; }
        public int OrderId { get; set; }
        public DateTime ShipmentDate { get; set; }
        public required string DeliveryStatus { get; set; }
        public Order? Order { get; set; }
    }
}
