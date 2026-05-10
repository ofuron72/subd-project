package financial.repository;

import financial.model.TransactionAuditEntity;
import org.springframework.data.jpa.repository.JpaRepository;

public interface TransactionAuditRepository
        extends JpaRepository<TransactionAuditEntity, Long> {
}
