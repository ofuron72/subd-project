package financial.service;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.StoredProcedureQuery;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;

@Service
@RequiredArgsConstructor
public class TransferService {

    @PersistenceContext
    private EntityManager entityManager;

    @Transactional
    public void transfer(
            Long fromAccountId,
            Long toAccountId,
            BigDecimal amount
    ) {

        StoredProcedureQuery query =
                entityManager.createStoredProcedureQuery(
                        "transfer_money"
                );

        query.registerStoredProcedureParameter(
                "p_from_account_id",
                Long.class,
                jakarta.persistence.ParameterMode.IN
        );

        query.registerStoredProcedureParameter(
                "p_to_account_id",
                Long.class,
                jakarta.persistence.ParameterMode.IN
        );

        query.registerStoredProcedureParameter(
                "p_amount",
                BigDecimal.class,
                jakarta.persistence.ParameterMode.IN
        );

        query.setParameter("p_from_account_id", fromAccountId);
        query.setParameter("p_to_account_id", toAccountId);
        query.setParameter("p_amount", amount);

        query.execute();
    }
}

