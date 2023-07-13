using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace TendonLoaderApi.Models;

[Table("Exercise")]
public partial class Exercise
{
    [Key]
    [Column("id")]
    public int Id { get; set; }

    [Required]
    [Column("user_id")]
    public int UserId { get; set; }

    [Column("prescription_id")]
    public int? PrescriptionId { get; set; }

    [Required]
    [Column("pain_score")]
    public double PainScore { get; set; }

    [Required]
    [Column("datetime")]
    [StringLength(50)]
    public string Datetime { get; set; } = null!;

    [Required]
    [Column("tolerable")]
    [StringLength(10)]
    public string Tolerable { get; set; } = null!;

    [Required]
    [Column("completed")]
    public bool Completed { get; set; }

    [Required]
    [Column("progressor_id")]
    [StringLength(30)]
    public string ProgressorId { get; set; } = null!;

    [Column("mvc_value")]
    public double? MvcValue { get; set; }

    [Required]
    [Column("data")]
    public string Data { get; set; } = null!;

    //[ForeignKey(nameof(UserId))]
    //[InverseProperty("Exercises")]
    //public virtual User User { get; set; } = null!;

    //[ForeignKey(nameof(PrescriptionId))]
    //[InverseProperty("Exercise")]
    //public virtual Prescription? Prescription { get; set; }
}
