using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using TendonLoaderApi.Data;
using TendonLoaderApi.Models;

namespace TendonLoaderApi.Controllers;

[Route("[controller]")]
[ApiController]
public class ExerciseController : ControllerBase
{
    private readonly TendonLoaderContext _context;

    public ExerciseController(TendonLoaderContext context) => _context = context;

    // GET: api/Exercise
    [HttpGet]
    public async Task<ActionResult<IEnumerable<Exercise>>> GetExercises()
    {
        if (_context.Exercises == null) return NotFound();

        return await _context.Exercises.AsNoTracking().ToListAsync();
    }

    // GET: api/Exercise/User/5
    [HttpGet("User/{id}")]
    public async Task<ActionResult<IEnumerable<Exercise>>> GetExercises(int id)
    {
        if (_context.Exercises == null) return NotFound();

        var exercises = _context.Exercises.Where(e => e.UserId == id);

        if (exercises.IsNullOrEmpty()) return NotFound();

        return await exercises.AsNoTracking().ToListAsync();
    }

    // GET: api/Exercise/5
    [HttpGet("{id}")]
    public async Task<ActionResult<Exercise>> GetExercise(int id)
    {
        if (_context.Exercises == null) return NotFound();

        var exercise = await _context.Exercises.FindAsync(id);

        if (exercise == null) return NotFound();

        return exercise;
    }

    // PUT: api/Exercise/5
    // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
    [HttpPut("{id}")]
    public async Task<IActionResult> PutExercise(int id, Exercise exercise)
    {
        if (id != exercise.Id) return BadRequest();

        _context.Entry(exercise).State = EntityState.Modified;

        try
        {
            await _context.SaveChangesAsync();
        }
        catch (DbUpdateConcurrencyException)
        {
            if (ExerciseExists(id)) throw;

            return NotFound();
        }

        return NoContent();
    }

    // POST: api/Exercise
    // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
    [HttpPost]
    public async Task<ActionResult<Exercise>> PostExercise(Exercise exercise)
    {
        if (_context.Exercises == null)
            return Problem("Entity set 'TendonLoaderContext.Exercises' is null.");

        _context.Exercises.Add(exercise);
        await _context.SaveChangesAsync();

        return CreatedAtAction("GetExercise", new { id = exercise.Id }, exercise);
    }

    // DELETE: api/Exercise/5
    [HttpDelete("{id}")]
    public async Task<IActionResult> DeleteExercise(int id)
    {
        if (_context.Exercises == null) return NotFound();

        var exercise = await _context.Exercises.FindAsync(id);
        if (exercise == null) return NotFound();

        _context.Exercises.Remove(exercise);
        await _context.SaveChangesAsync();

        return NoContent();
    }

    private bool ExerciseExists(int id) =>
        (_context.Exercises?.AsNoTracking().Any(e => e.Id == id)).GetValueOrDefault();
}
