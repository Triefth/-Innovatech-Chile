package cl.spa.backend.controller;

import cl.spa.backend.model.Plan;
import cl.spa.backend.service.PlanService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/planes")
@CrossOrigin(origins = "*") 
public class PlanController {
    
    private final PlanService planService;

    public PlanController(PlanService planService) {
        this.planService = planService;
    }
    @GetMapping
    public ResponseEntity<List<Plan>> getPlanes() {
        return new ResponseEntity<>(planService.obtenerTodosLosPlanes(), HttpStatus.OK);
    }
    @PostMapping
    public ResponseEntity<Plan> crearPlan(@RequestBody Plan plan) {
        return new ResponseEntity<>(planService.guardarPlan(plan), HttpStatus.CREATED);
    }
    @GetMapping("/{id}")
    public ResponseEntity<Plan> obtenerPlan(@PathVariable Long id) {
        return planService.obtenerPorId(id)
                .map(plan -> new ResponseEntity<>(plan, HttpStatus.OK))
                .orElseGet(() -> new ResponseEntity<>(HttpStatus.NOT_FOUND));
    }
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> eliminarPlan(@PathVariable Long id) {
        if (planService.eliminar(id)) {
            return new ResponseEntity<>(HttpStatus.NO_CONTENT);
        }
        return new ResponseEntity<>(HttpStatus.NOT_FOUND);
    }
}