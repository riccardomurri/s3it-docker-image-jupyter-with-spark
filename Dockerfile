FROM ansible/ubuntu14.04-ansible
MAINTAINER riccardo.murri@uzh.ch


## defaults
ENV JUPYTER_NOTEBOOK_PORT 8888
ENV JUPYTER_USER_NAME jupyter
ENV JUPYTER_USER_HOME /home/${JUPYTER_USER_NAME}

ENV SPARK_WEBUI_PORT 4040


## let Ansible do the installation work
WORKDIR /root
COPY playbooks/ playbooks
RUN ansible-playbook -i 'localhost,' -c local playbooks/spark.yml --skip-tags hadoop -e jupyter_user=${JUPYTER_USER_NAME} -e jupyter_home=${JUPYTER_USER_HOME}


## run the notebook and expose the web port
EXPOSE ${JUPYTER_NOTEBOOK_PORT} ${SPARK_WEBUI_PORT}
WORKDIR ${JUPYTER_USER_HOME}
# XXX: is a `USER user` line better?
CMD ["sudo", "-u", "${JUPYTER_USER_NAME}", "--login", "python", "-m", "notebook", "--ip=0.0.0.0", "--port=${JUPYTER_NOTEBOOK_PORT}", "--no-browser"]