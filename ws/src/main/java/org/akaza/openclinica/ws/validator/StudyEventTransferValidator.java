package org.akaza.openclinica.ws.validator;

import java.util.Date;

import org.akaza.openclinica.bean.core.Role;
import org.akaza.openclinica.bean.login.StudyUserRoleBean;
import org.akaza.openclinica.bean.managestudy.StudyBean;
import org.akaza.openclinica.bean.managestudy.StudyEventDefinitionBean;
import org.akaza.openclinica.bean.managestudy.StudySubjectBean;
import org.akaza.openclinica.dao.managestudy.StudyDAO;
import org.akaza.openclinica.dao.managestudy.StudyEventDefinitionDAO;
import org.akaza.openclinica.dao.managestudy.StudySubjectDAO;
import org.akaza.openclinica.ws.bean.StudyEventTransferBean;
import org.springframework.validation.Errors;
import org.springframework.validation.Validator;

import javax.sql.DataSource;

public class StudyEventTransferValidator implements Validator {

    DataSource dataSource;
    StudyDAO studyDAO;
    StudySubjectDAO studySubjectDAO;
    StudyEventDefinitionDAO studyEventDefinitionDAO;

    public StudyEventTransferValidator(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    @SuppressWarnings("rawtypes")
    public boolean supports(Class clazz) {
        return StudyEventTransferBean.class.equals(clazz);
    }

    public void validate(Object obj, Errors e) {
        StudyEventTransferBean studyEventTransferBean = (StudyEventTransferBean) obj;

        // Non Business Validation
        if (studyEventTransferBean.getStudyUniqueId() == null || studyEventTransferBean.getStudyUniqueId().length() < 1) {
            e.reject("studyEventTransferValidator.invalid_study_identifier");
            return;
        }

        // Business Validation
        StudyBean study = getStudyDAO().findByUniqueIdentifier(studyEventTransferBean.getStudyUniqueId());
        if (study == null) {
            e.reject("studyEventTransferValidator.study_does_not_exist", new Object[] { studyEventTransferBean.getStudyUniqueId() },
                    "Study identifier you specified " + studyEventTransferBean.getStudyUniqueId() + " does not correspond to a valid study.");
            return;}
        //validate study status
        if (study != null && !( study.getStatus().isAvailable() ||  study.getStatus().isPending()) ){
            e.reject("subjectTransferValidator.study_status_wrong", new Object[] { studyEventTransferBean.getStudyUniqueId() }, "Study "
            		+ studyEventTransferBean.getStudyUniqueId() +" has wrong status.");
            return;
        }
        

        StudyUserRoleBean role = studyEventTransferBean.getUser().getRoleByStudy(study);
        if (role.getId() == 0 || role.getRole().equals(Role.MONITOR)) {
        	  e.reject("studyEventTransferValidator.insufficient_permissions", "You do not have sufficient privileges to proceed with this operation.");
              return;
        }

        if (studyEventTransferBean.getSiteUniqueId() != null) {
            study = getStudyDAO().findSiteByUniqueIdentifier(studyEventTransferBean.getStudyUniqueId(), studyEventTransferBean.getSiteUniqueId());
            // verification 
            // go from here : study should be available or in design - verify
            if ( study == null){
        	            e.reject("subjectTransferValidator.site_does_not_exist", new Object[] { studyEventTransferBean.getSiteUniqueId() },
 	                    "Site identifier you specified does not correspond to a valid site.");
 	            return;
 	        }
            //validate site status
	        if (study != null && !study.getStatus().isAvailable()) {
	        
	            e.reject("subjectTransferValidator.site_status_wrong", new Object[] { studyEventTransferBean.getSiteUniqueId() }, "Site "
	            		+ study.getName() +" has wrong status. Subject can be added to an 'AVAILABLE' site only.");
	            return;
	        }
        }
       
        

        // Non Business Validation
        if (studyEventTransferBean.getStudySubjectId() == null || studyEventTransferBean.getStudySubjectId().length() < 1) {
            e.reject("studyEventTransferValidator.studySubjectId_required");
            return;
        }
        StudySubjectBean studySubject = getStudySubjectDAO().findByLabelAndStudy(studyEventTransferBean.getStudySubjectId(), study);
        //it is not null but label null
        if (studySubject == null || studySubject.getOid()== null) {
            e.reject("studyEventTransferValidator.study_subject_does_not_exist", new Object[] { studyEventTransferBean.getStudySubjectId() },
                    "StudySubject label you specified " + studyEventTransferBean.getStudySubjectId() + " does not correspond to a valid StudySubject.");
            return;
        }

        // Non Business Validation
        if (studyEventTransferBean.getEventDefinitionOID() == null || studyEventTransferBean.getEventDefinitionOID().length() < 1) {
            e.reject("studyEventTransferValidator.eventDefinitionOID_required");
            return;
        }
        
       
        if (studyEventTransferBean.getStartDateTime() == null) {
            e.reject("studyEventTransferValidator.startDateTime_required");
            return;
        }
        if (studyEventTransferBean.getLocation() == null || studyEventTransferBean.getLocation().length() < 1) {
            e.reject("studyEventTransferValidator.location_required");
            return;
        }
        
        if (studyEventTransferBean.getEndDateTime().compareTo(studyEventTransferBean.getStartDateTime())!= -1) {
            e.reject("studyEventTransferValidator.start_date_after_end_date", new Object[] { studyEventTransferBean.getEndDateTime(),studyEventTransferBean.getStartDateTime() },
                    "Start date "+studyEventTransferBean.getEndDateTime()+"  after end date ("+studyEventTransferBean.getStartDateTime()+").");
           
            return;
        }
        
        int parentStudyId = study.getId();
        StudyEventDefinitionBean studyEventDefinition =
            getStudyEventDefinitionDAO().findByOidAndStudy(studyEventTransferBean.getEventDefinitionOID(), study.getId(), parentStudyId);
        if (studyEventDefinition == null) {
            e.reject("studyEventTransferValidator.invalid_eventDefinitionOID", new Object[] { studyEventTransferBean.getEventDefinitionOID() },
                    "EventDefinitionOID you specified " + studyEventTransferBean.getEventDefinitionOID() + " is not valid.");
            return;
        }


    }

    public StudyDAO getStudyDAO() {
        return this.studyDAO != null ? studyDAO : new StudyDAO(dataSource);
    }

    public StudySubjectDAO getStudySubjectDAO() {
        return this.studySubjectDAO != null ? studySubjectDAO : new StudySubjectDAO(dataSource);
    }

    public StudyEventDefinitionDAO getStudyEventDefinitionDAO() {
        return this.studyEventDefinitionDAO != null ? studyEventDefinitionDAO : new StudyEventDefinitionDAO(dataSource);
    }

}
