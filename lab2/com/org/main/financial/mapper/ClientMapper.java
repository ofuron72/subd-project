package financial.mapper;

import financial.model.ClientEntity;
import financial.object.dto.request.CreateClientRequest;
import financial.object.dto.response.ClientResponse;
import org.springframework.stereotype.Component;

@Component
public class ClientMapper {
    public ClientEntity toEntity(CreateClientRequest request) {

        return ClientEntity.builder()
                .fullName(request.getFullName())
                .birthDate(request.getBirthDate())
                .passport(request.getPassport())
                .phone(request.getPhone())
                .email(request.getEmail())
                .build();
    }

    public ClientResponse toResponse(ClientEntity entity) {

        return ClientResponse.builder()
                .id(entity.getId())
                .fullName(entity.getFullName())
                .birthDate(entity.getBirthDate())
                .passport(entity.getPassport())
                .phone(entity.getPhone())
                .email(entity.getEmail())
                .build();
    }
}
