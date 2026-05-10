package financial.controller;

import financial.object.dto.request.CreateClientRequest;
import financial.object.dto.response.ClientResponse;
import financial.service.ClientService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/clients")
@RequiredArgsConstructor
public class ClientController {

    private final ClientService clientService;

    @PostMapping
    public ResponseEntity<ClientResponse> createClient(
            @RequestBody @Valid CreateClientRequest request
    ) {

        return ResponseEntity
                .status(HttpStatus.CREATED)
                .body(clientService.create(request));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ClientResponse> getClientById(
            @PathVariable Long id
    ) {

        return ResponseEntity.ok(clientService.getById(id));
    }
}
