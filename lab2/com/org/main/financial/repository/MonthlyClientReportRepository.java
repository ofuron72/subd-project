package financial.repository;


import financial.model.MonthlyClientReportEntity;
import org.springframework.data.jpa.repository.JpaRepository;

import java.time.LocalDate;
import java.util.List;

public interface MonthlyClientReportRepository
        extends JpaRepository<MonthlyClientReportEntity, Long> {

    List<MonthlyClientReportEntity> findByPeriodFromAndPeriodTo(
            LocalDate periodFrom,
            LocalDate periodTo
    );
}
