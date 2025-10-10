package main.java.com.org.model.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDate;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@Table(name = "client")
@Entity
public class ClientEntity extends BaseEntity {

    @Id
    @Column(name = "client_id")
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "client_seq_gen")
    @SequenceGenerator(name = "client_seq_gen", sequenceName = "client_seq")
    private Long id;

    @Column(name = "full_name")
    private String fullName;

    @Column(name = "birth_date")
    private LocalDate birthDate;

    @Column(name = "passport")
    private String passport;

    @Column(name = "phone")
    private String phone;

    @Column(name = "email")
    private String email;
}
