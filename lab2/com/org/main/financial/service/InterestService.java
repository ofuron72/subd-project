package financial.service;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.StoredProcedureQuery;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class InterestService {

    @PersistenceContext
    private EntityManager entityManager;

    @Transactional
    public void applyInterest() {

        StoredProcedureQuery query =
                entityManager.createStoredProcedureQuery(
                        "apply_interest"
                );

        query.execute();
    }
}
