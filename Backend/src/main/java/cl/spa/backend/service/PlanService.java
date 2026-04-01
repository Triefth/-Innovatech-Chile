package cl.spa.backend.service;

import cl.spa.backend.model.Plan;
import cl.spa.backend.repository.PlanRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class PlanService {

    private final PlanRepository planRepository;

    public PlanService(PlanRepository planRepository) {
        this.planRepository = planRepository;
    }

    public List<Plan> obtenerTodosLosPlanes() {
        return planRepository.findAll();
    }

    public Plan guardarPlan(Plan plan) {
        return planRepository.save(plan);
    }

    // Método agregado para el GET por ID
    public Optional<Plan> obtenerPorId(Long id) {
        return planRepository.findById(id);
    }

    // Método agregado para el DELETE
    public boolean eliminar(Long id) {
        if (planRepository.existsById(id)) {
            planRepository.deleteById(id);
            return true;
        }
        return false;
    }
}