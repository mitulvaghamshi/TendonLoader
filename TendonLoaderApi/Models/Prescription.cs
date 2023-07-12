using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace TendonLoaderApi.Models;

[Table("Prescription")]
public partial class Prescription
{
    [Key]
    [Column("id")]
    public int Id { get; set; }

    [Required]
    [Column("reps")]
    public int Reps { get; set; }

    [Required]
    [Column("sets")]
    public int Sets { get; set; }

    [Required]
    [Column("set_rest")]
    public int SetRest { get; set; }

    [Required]
    [Column("hold_time")]
    public int HoldTime { get; set; }

    [Required]
    [Column("rest_time")]
    public int RestTime { get; set; }

    [Required]
    [Column("mvc_duration")]
    public int MvcDuration { get; set; }

    [Required]
    [Column("target_load")]
    public double TargetLoad { get; set; }

    [InverseProperty("Prescription")]
    public virtual Exercise Exercise { get; set; } = null!;

    [InverseProperty("Prescription")]
    public virtual Settings Settings { get; set; } = null!;
}
