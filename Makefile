airflow-up:
	@docker-compose up --build

airflow-down:
	@docker-compose down

infra-get:
	cd environ/dev && terraform get;

infra-init: infra-get
	cd environ/dev && terraform init -upgrade;

infra-plan: infra-init
	cd environ/dev && terraform plan;

infra-apply: infra-plan
	cd environ/dev && terraform apply;

infra-destroy:
	cd environ/dev && terraform destroy;

clean:
	rm -rf postgres_data
