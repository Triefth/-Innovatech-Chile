package cl.spa.backend.service;

import cl.spa.backend.model.Plan;
import cl.spa.backend.repository.PlanRepository;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class PlanService {

    private final PlanRepository planRepository;

    public PlanService(PlanRepository planRepository) {
        this.planRepository = planRepository;
    }

    // Aquí iría la lógica de negocio (ej. calcular descuentos, validar reglas)
    public List<Plan> obtenerTodosLosPlanes() {
        return planRepository.findAll();
    }

    public Plan guardarPlan(Plan plan) {
        return planRepository.save(plan);
    }
}