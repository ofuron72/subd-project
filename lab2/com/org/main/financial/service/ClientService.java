package financial.service;

import financial.mapper.ClientMapper;
import financial.model.ClientEntity;
import financial.object.dto.request.CreateClientRequest;
import financial.object.dto.response.ClientResponse;
import financial.repository.ClientRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class ClientService {

    private final ClientRepository clientRepository;
    private final ClientMapper clientMapper;

    @Transactional
    public ClientResponse create(CreateClientRequest request) {

        ClientEntity entity =
                clientMapper.toEntity(request);

        ClientEntity saved =
                clientRepository.save(entity);

        return clientMapper.toResponse(saved);
    }

    @Transactional(readOnly = true)
    public ClientResponse getById(Long id) {

        ClientEntity entity = clientRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Client not found"));

        return clientMapper.toResponse(entity);
    }
}
