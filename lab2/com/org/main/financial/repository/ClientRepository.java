package financial.repository;

import financial.model.ClientEntity;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface ClientRepository
        extends JpaRepository<ClientEntity, Long> {

    Optional<ClientEntity> findByPassport(String passport);
}