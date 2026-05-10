package financial.object.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDate;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CreateClientRequest {

    @NotBlank
    private String fullName;

    @NotNull
    private LocalDate birthDate;

    @NotBlank
    private String passport;

    private String phone;

    private String email;
}
