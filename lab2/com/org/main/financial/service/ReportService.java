package financial.service;

import financial.mapper.MonthlyReportMapper;
import financial.object.dto.response.MonthlyReportResponse;
import financial.repository.MonthlyClientReportRepository;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.StoredProcedureQuery;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;

@Service
@RequiredArgsConstructor
public class ReportService {

    private final MonthlyClientReportRepository reportRepository;
    private final MonthlyReportMapper mapper;

    @PersistenceContext
    private EntityManager entityManager;

    @Transactional
    public void generate(LocalDate from, LocalDate to) {

        StoredProcedureQuery query =
                entityManager.createStoredProcedureQuery(
                        "generate_monthly_report"
                );

        query.registerStoredProcedureParameter(
                "p_from",
                LocalDate.class,
                jakarta.persistence.ParameterMode.IN
        );

        query.registerStoredProcedureParameter(
                "p_to",
                LocalDate.class,
                jakarta.persistence.ParameterMode.IN
        );

        query.setParameter("p_from", from);
        query.setParameter("p_to", to);

        query.execute();
    }

    @Transactional(readOnly = true)
    public List<MonthlyReportResponse> getAll() {

        return reportRepository.findAll()
                .stream()
                .map(mapper::toResponse)
                .toList();
    }
}
